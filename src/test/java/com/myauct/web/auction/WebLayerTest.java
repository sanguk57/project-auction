package com.myauct.web.auction;

import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import javax.sql.DataSource;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.junit.jupiter.web.SpringJUnitWebConfig;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.auctmaster.service.AuctionEventHub;
import com.myauct.web.global.CsrfFilter;
import com.myauct.web.global.SessionConst;
import com.myauct.web.support.TestDb;

/** 컨트롤러 · 필터: CSRF, 로그인, 권한, 실시간 연결, 화면 모델 */
@SpringJUnitWebConfig(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
class WebLayerTest {

	@Autowired WebApplicationContext ctx;
	@Autowired DataSource dataSource;
	@Autowired AuctionEventHub eventHub;

	MockMvc mvc;
	MockHttpSession session;
	String token;

	@BeforeEach
	void setup() throws Exception {
		TestDb.reset(dataSource);
		mvc = MockMvcBuilders.webAppContextSetup(ctx).addFilters(new CsrfFilter()).build();
		session = new MockHttpSession();
		mvc.perform(get("/users/login").session(session)); // 세션 + CSRF 토큰 발급
		token = (String) session.getAttribute(CsrfFilter.SESSION_KEY);
	}

	/**
	 * 로그인하면 세션 고정 공격 방지를 위해 세션이 새로 만들어지고 CSRF 토큰도 바뀐다.
	 * (브라우저도 로그인 후 새 화면을 불러오면서 새 토큰을 받는다) → 테스트도 새 세션 · 토큰으로 이어간다.
	 */
	private void login(String id) throws Exception {
		MockHttpSession fresh = (MockHttpSession) mvc.perform(post("/rest/loginChk").session(session)
				.header(CsrfFilter.HEADER, token).contentType(MediaType.APPLICATION_JSON)
				.content("{\"user_id\":\"" + id + "\",\"password\":\"test1234!\"}"))
				.andExpect(status().isOk())
				.andReturn().getRequest().getSession(false);
		session = fresh;
		mvc.perform(get("/aucts/index").session(session));
		token = (String) session.getAttribute(CsrfFilter.SESSION_KEY);
	}

	@Test
	void postWithoutCsrfTokenIsRejected() throws Exception {
		mvc.perform(post("/rest/loginChk").session(session).contentType(MediaType.APPLICATION_JSON)
				.content("{\"user_id\":\"seller01\",\"password\":\"test1234!\"}"))
				.andExpect(status().isForbidden());
		mvc.perform(post("/rest/loginChk").session(session).header(CsrfFilter.HEADER, "wrong-token")
				.contentType(MediaType.APPLICATION_JSON).content("{}"))
				.andExpect(status().isForbidden());
	}

	@Test
	void formPostAcceptsTokenAsParameter() throws Exception {
		mvc.perform(post("/aucts/deleteProduct").session(session).param("_csrf", token).param("anum", "2"))
				.andExpect(redirectedUrl("/users/login")); // CSRF 는 통과, 로그인이 안 돼 있어 로그인 화면으로
	}

	@Test
	void addressPopupCallbackIsExemptFromCsrf() throws Exception {
		mvc.perform(post("/users/jusoPopup").session(session).param("inputYn", "Y").param("roadFullAddr", "서울"))
				.andExpect(status().isOk());
	}

	@Test
	void loginStoresUserInSession() throws Exception {
		mvc.perform(post("/rest/loginChk").session(session).header(CsrfFilter.HEADER, token)
				.contentType(MediaType.APPLICATION_JSON).content("{\"user_id\":\"seller01\",\"password\":\"bad\"}"))
				.andExpect(status().isBadRequest());
		mvc.perform(post("/rest/loginChk").session(session).header(CsrfFilter.HEADER, token)
				.contentType(MediaType.APPLICATION_JSON).content("{\"user_id\":\"seller01\",\"password\":\"test1234!\"}"))
				.andExpect(status().isOk())
				.andExpect(request().sessionAttribute(SessionConst.LOGIN_USER, notNullValue()));
		org.junit.jupiter.api.Assertions.assertTrue(session.isInvalid(), "로그인 전 세션은 버려짐 (세션 고정 공격 방지)");
	}

	@Test
	void bidAndBuyNowRequireLogin() throws Exception {
		mvc.perform(put("/product-api/product_auction").session(session).header(CsrfFilter.HEADER, token)
				.contentType(MediaType.APPLICATION_JSON).content("{\"anum\":2,\"start_amt\":205000,\"amount\":1}"))
				.andExpect(status().isUnauthorized());
		mvc.perform(post("/product-api/buy_now").session(session).header(CsrfFilter.HEADER, token)
				.contentType(MediaType.APPLICATION_JSON).content("{\"anum\":1}"))
				.andExpect(status().isUnauthorized());
	}

	@Test
	void buyNowThroughApi() throws Exception {
		login("buyer001");
		mvc.perform(post("/product-api/buy_now").session(session).header(CsrfFilter.HEADER, token)
				.contentType(MediaType.APPLICATION_JSON).content("{\"anum\":1}"))
				.andExpect(status().isOk());
		mvc.perform(post("/product-api/buy_now").session(session).header(CsrfFilter.HEADER, token)
				.contentType(MediaType.APPLICATION_JSON).content("{\"anum\":1}"))
				.andExpect(status().isBadRequest())
				.andExpect(content().string(containsString("마감")));
	}

	@Test
	void mypageRequiresLogin() throws Exception {
		mvc.perform(get("/my").session(session)).andExpect(redirectedUrl("/users/login"));
		login("buyer002");
		mvc.perform(get("/my").session(session).param("tab", "bids"))
				.andExpect(status().isOk())
				.andExpect(model().attributeExists("bids", "wins", "sales"));
	}

	@Test
	void detailPageShowsWinnerContactOnlyToSellerAndWinner() throws Exception {
		login("seller01");
		AuctMasterDTO p = (AuctMasterDTO) mvc.perform(get("/aucts/productView").session(session).param("anum", "5"))
				.andExpect(model().attributeExists("counterpart"))
				.andReturn().getModelAndView().getModel().get("auctMasterDTO");
		assertEquals(AuctMasterDTO.END_SOLD, p.getEnd_chk(), "상세 화면을 여는 순간 낙찰 처리");

		session = new MockHttpSession(); // 다른 사람(낙찰자도 판매자도 아님)
		mvc.perform(get("/users/login").session(session));
		token = (String) session.getAttribute(CsrfFilter.SESSION_KEY);
		login("buyer001");
		mvc.perform(get("/aucts/productView").session(session).param("anum", "5"))
				.andExpect(model().attributeDoesNotExist("counterpart"));
	}

	@Test
	void listFiltersAreApplied() throws Exception {
		mvc.perform(get("/aucts/about").session(session).param("status", "ready"))
				.andExpect(model().attribute("paging", org.hamcrest.Matchers.hasProperty("total",
						org.hamcrest.CoreMatchers.is(1))));
	}

	@Test
	void eventStreamOpens() throws Exception {
		mvc.perform(get("/product-api/stream").param("anum", "2"))
				.andExpect(request().asyncStarted());
		assertEquals(1, eventHub.listenerCount(2));
	}
}
