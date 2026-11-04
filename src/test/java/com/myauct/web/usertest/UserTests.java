package com.myauct.web.usertest;

import static org.junit.jupiter.api.Assertions.assertNull;

import org.springframework.beans.factory.annotation.Autowired;

import org.junit.jupiter.api.Test;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import com.myauct.web.domain.user.dto.UserDTO;
import com.myauct.web.domain.user.service.UserService;

import lombok.extern.slf4j.Slf4j;

/** DB 연결이 필요한 테스트 */
@SpringJUnitConfig(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Slf4j
public class UserTests {
	@Autowired
	private UserService userService;

	// 아이디 찾기
	@Test
	public void getUserIdTest() {
		log.info(userService.getUserId("세종이", "010-0184-5154"));
	}

	@Test
	public void getUnum() {
		log.info("{}", userService.getUnum("DD", "010-0184-5154"));
	}

	@Test
	public void userIdChkTest() {
		log.info("{}", userService.existsUserId("CCC"));
	}

	@Test
	public void loginWrongPassword() {
		assertNull(userService.login("BBB", "wrong-password"));
	}

	@Test
	public void loginResultHasNoPassword() {
		UserDTO user = userService.login("BBB", "1234");
		if (user != null) {
			assertNull(user.getPassword(), "세션에 넣을 객체에 비밀번호가 남아 있으면 안 됨");
		}
	}
}
