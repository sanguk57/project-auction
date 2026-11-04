package com.myauct.web.global;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

/** 로그인하지 않은 사용자가 상품 등록/수정/삭제 화면에 들어오면 로그인 페이지로 보낸다. */
public class LoginCheckInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute(SessionConst.LOGIN_USER) == null) {
			response.sendRedirect(request.getContextPath() + "/users/login");
			return false;
		}
		return true;
	}
}
