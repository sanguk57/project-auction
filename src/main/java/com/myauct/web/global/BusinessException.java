package com.myauct.web.global;

import org.springframework.http.HttpStatus;

/** 사용자에게 그대로 보여줘도 되는 메시지를 담은 예외 (입찰 실패, 권한 없음 등) */
public class BusinessException extends RuntimeException {
	private static final long serialVersionUID = 1L;

	private final HttpStatus status;

	public BusinessException(HttpStatus status, String message) {
		super(message);
		this.status = status;
	}

	public HttpStatus getStatus() {
		return status;
	}

	public static BusinessException badRequest(String message) {
		return new BusinessException(HttpStatus.BAD_REQUEST, message);
	}

	public static BusinessException unauthorized() {
		return new BusinessException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
	}

	public static BusinessException forbidden() {
		return new BusinessException(HttpStatus.FORBIDDEN, "권한이 없습니다.");
	}
}
