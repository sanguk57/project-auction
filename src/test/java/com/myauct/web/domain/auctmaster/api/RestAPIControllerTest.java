package com.myauct.web.domain.auctmaster.api;

import static org.hamcrest.CoreMatchers.notNullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.springframework.beans.factory.annotation.Autowired;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit.jupiter.web.SpringJUnitWebConfig;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.myauct.web.domain.user.dto.UserDTO;
import com.myauct.web.global.SessionConst;

/** DB 연결이 필요한 테스트 (로컬 MySQL + C:/myauct/app.properties 필요) */
@SpringJUnitWebConfig(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
public class RestAPIControllerTest {

	@Autowired
	private WebApplicationContext ctx;

	private MockMvc mockMvc;

	@BeforeEach
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}

	private static UserDTO loginUser(int unum) {
		UserDTO user = new UserDTO();
		user.setUnum(unum);
		return user;
	}

	@Test
	public void userLoginTest() throws Exception {
		String ok = "{\"user_id\" : \"DDD\", \"password\" : \"1234\"}";
		String wrongId = "{\"user_id\" : \"DDDD\", \"password\" : \"1234\"}";
		String wrongPw = "{\"user_id\" : \"DDD\", \"password\" : \"12345\"}";

		// 성공하면 세션에 로그인 정보가 들어가야 한다
		mockMvc.perform(post("/web/rest/loginChk").contextPath("/web")
				.contentType(MediaType.APPLICATION_JSON).content(ok))
				.andExpect(status().isOk())
				.andExpect(request().sessionAttribute(SessionConst.LOGIN_USER, notNullValue()))
				.andDo(print());
		mockMvc.perform(post("/web/rest/loginChk").contextPath("/web")
				.contentType(MediaType.APPLICATION_JSON).content(wrongId))
				.andExpect(status().isBadRequest());
		mockMvc.perform(post("/web/rest/loginChk").contextPath("/web")
				.contentType(MediaType.APPLICATION_JSON).content(wrongPw))
				.andExpect(status().isBadRequest());
	}

	@Test
	public void modifyPasswordWithoutVerification() throws Exception {
		// 본인확인(/rest/getPw) 없이 남의 unum 으로 비밀번호 변경 시도 → 거부
		mockMvc.perform(put("/web/rest/modifyPassword").contextPath("/web")
				.contentType(MediaType.APPLICATION_JSON)
				.content("{\"unum\" : 1, \"password\" : \"hacked123!\"}"))
				.andExpect(status().isForbidden());
	}

	@Test
	public void product_category() throws Exception {
		mockMvc.perform(post("/web/product-api/product_category").contextPath("/web"))
				.andExpect(status().isOk()).andDo(print());
	}

	@Test
	public void uploadAjaxAction() throws Exception {
		mockMvc.perform(post("/web/product-api/uploadAjaxAction").contextPath("/web")
				.contentType(MediaType.APPLICATION_JSON).content("{\"anum\" : [56, 57]}"))
				.andExpect(status().isOk()).andDo(print());
	}

	@Test
	public void uploadAjaxActionReturnsJson() throws Exception {
		// 빈 목록이면 DB 를 조회하지 않음 → Jackson 3 JSON 변환만 확인
		mockMvc.perform(post("/web/product-api/uploadAjaxAction").contextPath("/web")
				.contentType(MediaType.APPLICATION_JSON).content("{\"anum\" : []}"))
				.andExpect(status().isOk())
				.andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.content().string("{}"));
	}

	@Test
	public void suggestEmptyOrTooLongReturnsEmptyList() throws Exception {
		// 빈 검색어 / 30자 초과는 DB 를 조회하지 않고 바로 빈 목록
		mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
				.get("/web/product-api/suggest").contextPath("/web").param("q", "  "))
				.andExpect(status().isOk())
				.andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.content().string("[]"));
		mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
				.get("/web/product-api/suggest").contextPath("/web").param("q", "a".repeat(31)))
				.andExpect(status().isOk())
				.andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.content().string("[]"));
	}

	@Test
	public void concernRequiresLogin() throws Exception {
		// 예전에는 body 의 unum 만 바꾸면 남의 이름으로 찜할 수 있었음
		mockMvc.perform(post("/web/product-api/product_concern").contextPath("/web")
				.contentType(MediaType.APPLICATION_JSON).content("{\"anum\" : 52, \"unum\" : 6}"))
				.andExpect(status().isUnauthorized());
	}

	@Test
	public void product_concern() throws Exception {
		mockMvc.perform(post("/web/product-api/product_concern").contextPath("/web")
				.sessionAttr(SessionConst.LOGIN_USER, loginUser(6))
				.contentType(MediaType.APPLICATION_JSON).content("{\"anum\" : 52}"))
				.andExpect(status().isOk());
	}

	@Test
	public void product_unconcern() throws Exception {
		mockMvc.perform(delete("/web/product-api/product_unconcern").contextPath("/web")
				.sessionAttr(SessionConst.LOGIN_USER, loginUser(6))
				.contentType(MediaType.APPLICATION_JSON).content("{\"anum\" : 52}"))
				.andExpect(status().isOk());
	}

	@Test
	public void concern_list() throws Exception {
		mockMvc.perform(post("/web/product-api/concern_list").contextPath("/web")
				.sessionAttr(SessionConst.LOGIN_USER, loginUser(6)))
				.andExpect(status().isOk()).andDo(print());
	}

	@Test
	public void memoList() throws Exception {
		mockMvc.perform(post("/web/product-api/memoList").contextPath("/web")
				.contentType(MediaType.APPLICATION_JSON).content("{\"qnum\" : 2}"))
				.andExpect(status().isOk()).andDo(print());
	}
}
