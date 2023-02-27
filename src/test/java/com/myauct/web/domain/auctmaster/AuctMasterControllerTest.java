package com.myauct.web.domain.auctmaster;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;

import javax.inject.Inject;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
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
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml", "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
public class AuctMasterControllerTest {
	 @Inject
	 private WebApplicationContext ctx;
	 
	
	private MockMvc mockMvc;

	@Before
	public void setup() {
		this.mockMvc =	MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	@Test
	public void pagingTset() throws Exception{
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/aucts/index")
				.param("value", "123")
				.param("nowPage", "1")
				.param("cntPerPage", "4"))
				.andDo(print())
				.andExpect(model().attributeExists("productList")));
	}
	@Test 
	public void productListTest() throws Exception{
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/aucts/index")
				.param("anum", "4"))
				.andDo(print())
				.andExpect(model().attributeExists("productList")));
	}
	@Test
	public void productView() throws Exception{
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/aucts/productView")
				.param("anum", "36"))
				.andDo(print())
				.andExpect(model().attributeExists("memoCntList")));
	}
	
	
	@Test
	public void modifyProduct() throws Exception{
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/aucts/modifyProduct")
				.param("anum", "36"))
				.andDo(print()));
				
	}
	
	@Test
	public void deleteProduct() throws Exception{
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/aucts/modifyProduct")
				.param("anum", "53"))
				.andDo(print()));
	}
	}
	

