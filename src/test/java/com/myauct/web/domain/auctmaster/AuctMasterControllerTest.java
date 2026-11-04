package com.myauct.web.domain.auctmaster;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;

import org.springframework.beans.factory.annotation.Autowired;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.context.junit.jupiter.web.SpringJUnitWebConfig;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

/** DB 연결이 필요한 테스트 (로컬 MySQL + C:/myauct/app.properties 필요) */
@SpringJUnitWebConfig(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
public class AuctMasterControllerTest {
	@Autowired
	private WebApplicationContext ctx;

	private MockMvc mockMvc;

	@BeforeEach
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}

	@Test
	public void pagingTest() throws Exception {
		mockMvc.perform(get("/aucts/index").param("value", "123").param("nowPage", "1").param("cntPerPage", "4"))
				.andDo(print())
				.andExpect(model().attributeExists("productList", "paging"));
	}

	@Test
	public void productView() throws Exception {
		mockMvc.perform(get("/aucts/productView").param("anum", "36"))
				.andExpect(model().attributeExists("boardList", "auctMasterDTO"));
	}

	@Test
	public void modifyProductRequiresLogin() throws Exception {
		mockMvc.perform(get("/aucts/modifyProduct").param("anum", "36"))
				.andExpect(redirectedUrl("/users/login"));
	}

	@Test
	public void deleteProductRequiresLogin() throws Exception {
		mockMvc.perform(post("/aucts/deleteProduct").param("anum", "53"))
				.andExpect(redirectedUrl("/users/login"));
	}
}
