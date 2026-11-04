package com.myauct.web.mapper;

import org.junit.jupiter.api.Test;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;
import org.springframework.beans.factory.annotation.Autowired;

import com.myauct.web.domain.user.dao.UserDAO;

import lombok.extern.slf4j.Slf4j;

/** DB 연결이 필요한 테스트 */
@SpringJUnitConfig(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Slf4j
public class MapperTests {

	@Autowired
	private UserDAO userMapper;

	@Test
	public void getUser() {
		log.info("{}", userMapper.getUser("DDD"));
	}
}
