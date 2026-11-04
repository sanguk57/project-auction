package com.myauct.web.domain.user.api;

import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.myauct.web.domain.user.dto.UserDTO;
import com.myauct.web.domain.user.service.UserService;
import com.myauct.web.global.SessionConst;

import lombok.RequiredArgsConstructor;

/*
 * 삭제한 API
 *  - /rest/userList : 전체 회원 정보(비밀번호 포함)를 아무나 조회할 수 있었음
 */
@RestController
@RequestMapping("/rest")
@RequiredArgsConstructor
public class UserApi {

	private final UserService userService;

	/**
	 * 로그인. 비밀번호 확인과 세션 저장을 서버에서 한 번에 처리한다.
	 * (예전: 여기서 OK 만 응답 → 브라우저가 /aucts/loginUser 에 아이디만 보내서 로그인
	 *  → 비밀번호 없이 아무 아이디로나 로그인 가능했음)
	 */
	@PostMapping("/loginChk")
	public ResponseEntity<String> loginChk(@RequestBody Map<String, String> map, HttpServletRequest request) {
		UserDTO user = userService.login(map.get("user_id"), map.get("password"));
		if (user == null) {
			// 아이디가 틀렸는지 비밀번호가 틀렸는지 알려주면 가입된 아이디를 알아낼 수 있어서 메시지를 하나로 합침
			return text("아이디 또는 비밀번호를 확인해주세요.", HttpStatus.BAD_REQUEST);
		}

		// 세션 고정 공격 방지: 로그인 전에 쓰던 세션을 버리고 새로 만든다
		HttpSession old = request.getSession(false);
		if (old != null) {
			old.invalidate();
		}
		request.getSession(true).setAttribute(SessionConst.LOGIN_USER, user);
		return text("로그인 성공", HttpStatus.OK);
	}

	@PostMapping("/getId")
	public ResponseEntity<String> getUserId(@RequestBody Map<String, String> map) {
		String id = userService.getUserId(map.get("name"), map.get("phone"));
		if (id != null) {
			return text(id, HttpStatus.OK);
		}
		return text("가입된 회원이 아닙니다.", HttpStatus.BAD_REQUEST);
	}

	/**
	 * 비밀번호 찾기 1단계: 아이디 + 전화번호로 본인 확인.
	 * 확인된 회원번호는 브라우저로 보내지 않고 세션에만 저장한다.
	 */
	@PostMapping("/getPw")
	public ResponseEntity<String> getUserPw(@RequestBody Map<String, String> map, HttpSession session) {
		Integer unum = userService.getUnum(map.get("user_id"), map.get("phone"));
		if (unum == null) {
			return text("가입된 정보가 없습니다.", HttpStatus.BAD_REQUEST);
		}
		session.setAttribute(SessionConst.PW_RESET_UNUM, unum);
		return text("확인되었습니다.", HttpStatus.OK);
	}

	/**
	 * 비밀번호 찾기 2단계: 새 비밀번호 저장.
	 * (예전: 요청 body 의 unum 을 그대로 사용 → 남의 회원번호를 넣으면 남의 비밀번호를 바꿀 수 있었음)
	 */
	@PutMapping("/modifyPassword")
	public ResponseEntity<String> modifyPassword(@RequestBody Map<String, String> map, HttpSession session) {
		Integer unum = (Integer) session.getAttribute(SessionConst.PW_RESET_UNUM);
		if (unum == null) {
			return text("본인 확인을 먼저 진행해주세요.", HttpStatus.FORBIDDEN);
		}
		String password = map.get("password");
		if (password == null || password.length() < 8) {
			return text("비밀번호는 8자 이상이어야 합니다.", HttpStatus.BAD_REQUEST);
		}
		if (!userService.modifyUserPw(password, unum)) {
			return text("비밀번호 변경에 실패했습니다.", HttpStatus.BAD_REQUEST);
		}
		session.removeAttribute(SessionConst.PW_RESET_UNUM);
		return text("비밀번호 수정 완료", HttpStatus.OK);
	}

	@PostMapping("/userIdChk")
	public ResponseEntity<Integer> userIdChk(@RequestBody Map<String, String> map) {
		int cnt = userService.existsUserId(map.get("user_id")) ? 1 : 0;
		return new ResponseEntity<>(cnt, HttpStatus.OK);
	}

	private static ResponseEntity<String> text(String body, HttpStatus status) {
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "text/plain;charset=UTF-8");
		return new ResponseEntity<>(body, headers, status);
	}
}
