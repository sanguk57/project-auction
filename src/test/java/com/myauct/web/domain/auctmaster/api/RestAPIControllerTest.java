package com.myauct.web.domain.auctmaster.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import javax.inject.Inject;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@Log4j
@WebAppConfiguration
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
public class RestAPIControllerTest {

	@Inject
	private WebApplicationContext ctx;

	private MockMvc mockMvc;

	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}

	@Test
	public void userLoginTest() throws Exception {
		String data = "{\"user_id\" : \"DDD\", \"password\" : \"1234\"}";
		String data1 = "{\"user_id\" : \"DDDD\", \"password\" : \"1234\"}";
		String data2 = "{\"user_id\" : \"DDD\", \"password\" : \"12345\"}";

		this.mockMvc.perform(
				post("/web/rest/loginChk").contextPath("/web").contentType(MediaType.APPLICATION_JSON).content(data))
				.andExpect(status().isOk()).andDo(print());

		this.mockMvc.perform(
				post("/web/rest/loginChk").contextPath("/web").contentType(MediaType.APPLICATION_JSON).content(data1))
				.andExpect(status().isBadRequest()).andDo(print());

		this.mockMvc.perform(
				post("/web/rest/loginChk").contextPath("/web").contentType(MediaType.APPLICATION_JSON).content(data2))
				.andExpect(status().isBadRequest()).andDo(print());
	}

	@Test
	public void product_category() throws Exception {
		this.mockMvc.perform(MockMvcRequestBuilders.post("/web/product-api/product_category").contextPath("/web"))
				.andExpect(status().isOk()).andDo(print());
	}

	@Test
	public void uploadAjaxAction() throws Exception {
		String data = "{\"anum\" : 56}";

		this.mockMvc
				.perform(MockMvcRequestBuilders.post("/web/product-api/uploadAjaxAction").contextPath("/web")
						.contentType(MediaType.APPLICATION_JSON).characterEncoding("utf-8").content(data))
				.andExpect(status().isBadRequest()).andDo(print());
	}

	@Test
	public void product_concern() throws Exception {
		String data = "{\"anum\" : 52, \"unum\" : 6}";

		this.mockMvc
				.perform(MockMvcRequestBuilders.post("/web/product-api/product_concern").contextPath("/web")
						.contentType(MediaType.APPLICATION_JSON).characterEncoding("utf-8").content(data))
				.andExpect(status().isOk()).andDo(print());
	}

	@Test
	public void product_unconcern() throws Exception {
		String data = "{\"anum\" : 52, \"unum\" : 6}";

		this.mockMvc
				.perform(MockMvcRequestBuilders.delete("/web/product-api/product_unconcern").contextPath("/web")
						.contentType(MediaType.APPLICATION_JSON).characterEncoding("utf-8").content(data))
				.andExpect(status().isOk()).andDo(print());
	}

	@Test
	public void concern_list() throws Exception {
		String data = "{\"unum\" : 6}";

		this.mockMvc
				.perform(MockMvcRequestBuilders.post("/web/product-api/concern_list").contextPath("/web")
						.contentType(MediaType.APPLICATION_JSON).characterEncoding("utf-8").content(data))
				.andExpect(status().isOk()).andDo(print());
	}

	@Test
	public void memoList() throws Exception {
		String data = "{\"qnum\" : 2}";

		this.mockMvc
				.perform(MockMvcRequestBuilders.post("/web/product-api/memoList").contextPath("/web")
						.contentType(MediaType.APPLICATION_JSON).characterEncoding("utf-8").content(data))
				.andExpect(status().isOk()).andDo(print());
	}
}
