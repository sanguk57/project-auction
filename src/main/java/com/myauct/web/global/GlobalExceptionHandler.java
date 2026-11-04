package com.myauct.web.global;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 컨트롤러에서 던진 예외를 한 곳에서 처리한다.
 * (예전에는 예외가 나면 톰캣 500 에러 페이지 + 스택트레이스가 그대로 사용자에게 보였음)
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

	private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

	@ExceptionHandler(BusinessException.class)
	public ResponseEntity<String> handleBusiness(BusinessException e) {
		return text(e.getStatus(), e.getMessage());
	}

	@ExceptionHandler({ IllegalArgumentException.class, NullPointerException.class, ClassCastException.class })
	public ResponseEntity<String> handleBadRequest(RuntimeException e) {
		logger.warn("잘못된 요청", e);
		return text(HttpStatus.BAD_REQUEST, "요청 값이 올바르지 않습니다.");
	}

	private ResponseEntity<String> text(HttpStatus status, String message) {
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "text/plain;charset=UTF-8");
		return new ResponseEntity<>(message, headers, status);
	}
}
