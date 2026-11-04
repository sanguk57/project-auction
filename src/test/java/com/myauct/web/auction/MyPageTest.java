package com.myauct.web.auction;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.sql.DataSource;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import com.myauct.web.domain.auctmaster.service.AuctionCloseService;
import com.myauct.web.domain.mypage.dto.MyAuctionDTO;
import com.myauct.web.domain.mypage.service.MyPageService;
import com.myauct.web.domain.user.service.UserService;
import com.myauct.web.global.BusinessException;
import com.myauct.web.support.TestDb;

/** 마이페이지 (입찰 내역 상태 · 낙찰 · 판매 현황) 와 회원 탈퇴 규칙 */
@SpringJUnitConfig(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
class MyPageTest {

	@Autowired DataSource dataSource;
	@Autowired MyPageService myPage;
	@Autowired AuctionCloseService closeService;
	@Autowired UserService userService;

	@BeforeEach
	void reset() {
		TestDb.reset(dataSource);
		closeService.closeIfEnded(5); // buyer002 낙찰
	}

	private static Map<Integer, String> statusByProduct(List<MyAuctionDTO> list) {
		return list.stream().collect(Collectors.toMap(MyAuctionDTO::getAnum, MyAuctionDTO::getMy_status));
	}

	@Test
	void bidHistoryShowsMyStatusPerProduct() {
		Map<Integer, String> buyer002 = statusByProduct(myPage.myBids(3));
		assertEquals("TOP", buyer002.get(1));  // 상품 1 최고 입찰
		assertEquals("WON", buyer002.get(5));  // 상품 5 낙찰

		Map<Integer, String> buyer001 = statusByProduct(myPage.myBids(2));
		assertEquals("OUTBID", buyer001.get(1));
		assertEquals("LOST", buyer001.get(5));
	}

	@Test
	void winnerSeesSellerContactAndSellerSeesWinner() {
		MyAuctionDTO won = myPage.myWins(3).get(0);
		assertEquals(5, won.getAnum());
		assertEquals("김판매", won.getOther_name());
		assertEquals("010-1111-1111", won.getOther_phone());

		MyAuctionDTO sold = myPage.mySales(1).stream().filter(s -> s.getAnum() == 5).findFirst().orElseThrow();
		assertEquals("박입찰", sold.getOther_name());
		assertEquals(64_000, sold.getWin_amt());
	}

	@Test
	void withdrawIsBlockedWhileSellingOrLeading() {
		BusinessException seller = assertThrows(BusinessException.class, () -> myPage.withdraw(1, "test1234!"));
		assertTrue(seller.getMessage().contains("판매"));
		BusinessException leader = assertThrows(BusinessException.class, () -> myPage.withdraw(3, "test1234!"));
		assertTrue(leader.getMessage().contains("최고 입찰"));
		assertThrows(BusinessException.class, () -> myPage.withdraw(2, "wrong-password"));
	}

	@Test
	void withdrawRemovesPersonalInfoAndFreesTheId() {
		assertTrue(userService.existsUserId("buyer001"));
		myPage.withdraw(2, "test1234!");

		assertNull(userService.login("buyer001", "test1234!"), "탈퇴한 계정으로는 로그인할 수 없음");
		assertFalse(userService.existsUserId("buyer001"), "원래 아이디는 다시 쓸 수 있음");
		assertNull(userService.getContact(2));
		assertNotNull(myPage.myBids(2), "입찰 기록은 남아 있음");
	}
}
