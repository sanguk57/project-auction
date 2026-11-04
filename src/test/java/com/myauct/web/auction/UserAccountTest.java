package com.myauct.web.auction;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import javax.sql.DataSource;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import com.myauct.web.domain.user.dto.UserDTO;
import com.myauct.web.domain.user.service.UserService;
import com.myauct.web.global.BusinessException;
import com.myauct.web.support.TestDb;

/** 로그인 · 비밀번호 · 내 정보 수정 */
@SpringJUnitConfig(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
class UserAccountTest {

	@Autowired DataSource dataSource;
	@Autowired UserService userService;

	@BeforeEach
	void reset() {
		TestDb.reset(dataSource);
	}

	@Test
	void loginReturnsUserWithoutPassword() {
		UserDTO u = userService.login("seller01", "test1234!");
		assertNotNull(u);
		assertNull(u.getPassword(), "세션에 넣을 객체에 비밀번호가 남으면 안 됨");
		assertNull(userService.login("seller01", "wrong"));
		assertNull(userService.login("nobody", "test1234!"));
	}

	@Test
	void plainTextPasswordIsUpgradedToBcryptOnLogin() {
		JdbcTemplate jdbc = new JdbcTemplate(dataSource);
		jdbc.update("insert into User_List (user_id, password, name, phone) values ('legacy01', 'old1234', '옛회원', '010-9999-9999')");
		assertNotNull(userService.login("legacy01", "old1234"));
		String stored = jdbc.queryForObject("select password from User_List where user_id = 'legacy01'", String.class);
		assertTrue(stored.startsWith("$2"), "로그인 후 BCrypt 로 다시 저장");
		assertNotNull(userService.login("legacy01", "old1234"));
	}

	@Test
	void changePasswordRequiresCurrentPasswordAndRules() {
		assertThrows(BusinessException.class, () -> userService.changePassword(2, "wrong", "new1234!x"));
		assertThrows(BusinessException.class, () -> userService.changePassword(2, "test1234!", "short"));
		userService.changePassword(2, "test1234!", "new1234!x");
		assertNotNull(userService.login("buyer001", "new1234!x"));
		assertNull(userService.login("buyer001", "test1234!"));
	}

	@Test
	void updateProfileValidatesAndSaves() {
		UserDTO bad = new UserDTO();
		bad.setName("새이름");
		bad.setPhone("12345");
		assertThrows(BusinessException.class, () -> userService.updateProfile(2, bad));

		UserDTO form = new UserDTO();
		form.setName(" 새이름 ");
		form.setPhone("010-5555-6666");
		form.setEmail("");
		UserDTO saved = userService.updateProfile(2, form);
		assertEquals("새이름", saved.getName());
		assertEquals("010-5555-6666", saved.getPhone());
		assertNull(saved.getEmail(), "빈 칸은 null 로 저장");
		assertNull(saved.getPassword());
	}
}
