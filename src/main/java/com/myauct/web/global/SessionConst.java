package com.myauct.web.global;

/** 세션 attribute 이름을 한 곳에서 관리 (오타 방지) */
public final class SessionConst {
	/** 로그인한 회원 (UserDTO, 비밀번호는 비워서 보관) */
	public static final String LOGIN_USER = "user";
	/** 비밀번호 찾기에서 본인확인이 끝난 회원번호 */
	public static final String PW_RESET_UNUM = "pwResetUnum";

	private SessionConst() {
	}
}
