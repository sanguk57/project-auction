package com.myauct.web.global;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Set;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * CSRF(사이트 간 요청 위조) 방어.
 * 다른 사이트에 숨겨 둔 폼이 로그인한 사용자의 브라우저로 입찰 · 삭제 요청을 보내는 것을 막는다.
 *
 *  - 세션마다 무작위 토큰을 만들어 JSP 의 meta 태그(csrf-token)로 내려준다 (request 속성 _csrf)
 *  - POST · PUT · DELETE 요청은 헤더 X-CSRF-TOKEN 또는 파라미터 _csrf 가 같아야 통과
 *  - /web/js/csrf.js 가 fetch · jQuery 요청과 폼 전송에 토큰을 자동으로 붙인다
 *  - 주소 검색 팝업은 juso.go.kr 이 결과를 POST 로 돌려보내므로(외부 사이트) 제외
 */
public class CsrfFilter implements Filter {

	public static final String SESSION_KEY = "CSRF_TOKEN";
	public static final String REQUEST_ATTR = "_csrf";
	public static final String HEADER = "X-CSRF-TOKEN";
	public static final String PARAM = "_csrf";

	private static final Set<String> SAFE_METHODS = Set.of("GET", "HEAD", "OPTIONS", "TRACE");
	private static final Set<String> EXEMPT_PATHS = Set.of("/users/jusoPopup", "/aucts/jusoPopup");
	private static final SecureRandom RANDOM = new SecureRandom();

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;

		String path = request.getRequestURI().substring(request.getContextPath().length());
		boolean isStatic = path.startsWith("/resources/") || path.startsWith("/js/") || path.startsWith("/css/")
				|| path.startsWith("/images/") || path.startsWith("/vendor/") || path.startsWith("/upload/");
		if (isStatic) {
			chain.doFilter(req, res);
			return;
		}

		HttpSession session = request.getSession(true);
		String token = (String) session.getAttribute(SESSION_KEY);
		if (token == null) {
			token = newToken();
			session.setAttribute(SESSION_KEY, token);
		}
		request.setAttribute(REQUEST_ATTR, token);

		if (!SAFE_METHODS.contains(request.getMethod()) && !EXEMPT_PATHS.contains(path)) {
			String sent = request.getHeader(HEADER);
			if (sent == null || sent.isEmpty()) {
				sent = request.getParameter(PARAM);
			}
			if (!matches(token, sent)) {
				reject(request, response);
				return;
			}
		}
		chain.doFilter(req, res);
	}

	private static String newToken() {
		byte[] bytes = new byte[32];
		RANDOM.nextBytes(bytes);
		return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
	}

	/** 길이가 같은지까지 시간 차이로 드러나지 않게 비교 */
	private static boolean matches(String expected, String actual) {
		return actual != null && MessageDigest.isEqual(expected.getBytes(StandardCharsets.UTF_8),
				actual.getBytes(StandardCharsets.UTF_8));
	}

	private static void reject(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setStatus(HttpServletResponse.SC_FORBIDDEN);
		String message = "보안 확인에 실패했습니다. 페이지를 새로고침한 뒤 다시 시도해주세요.";
		String accept = request.getHeader("Accept");
		if (accept != null && accept.contains("text/html")) {
			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().write("<!DOCTYPE html><html lang=\"ko\"><head><meta charset=\"UTF-8\"><title>요청 거부</title></head>"
					+ "<body style=\"font-family:sans-serif;text-align:center;padding-top:80px;color:#1e293b\">"
					+ "<h2>요청을 처리할 수 없습니다</h2><p>" + message + "</p>"
					+ "<p><a href=\"javascript:history.back()\">이전 화면으로</a></p></body></html>");
		} else {
			response.setContentType("text/plain;charset=UTF-8");
			response.getWriter().write(message);
		}
	}
}
