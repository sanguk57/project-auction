package com.myauct.web.auction;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import javax.sql.DataSource;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.auctmaster.service.AuctMasterService;
import com.myauct.web.domain.auctmaster.service.AuctionCloseService;
import com.myauct.web.global.BusinessException;
import com.myauct.web.support.TestDb;

/**
 * 입찰 · 즉시구매 · 낙찰 처리 규칙 (H2 메모리 DB, sql/sample-data.sql 기준)
 *  상품 1: 진행 중, 현재가 420,000, 입찰 단위 10,000, 즉시구매가 600,000, 최고 입찰자 buyer002(3)
 *  상품 2: 진행 중, 현재가 200,000, 입찰 단위 5,000, 입찰 없음, 수량 2
 *  상품 3: 시작 전 / 상품 4: 마감 · 입찰 없음 / 상품 5: 마감 · 최고 입찰 buyer002 64,000
 *  회원: seller01(1, 판매자) buyer001(2) buyer002(3)
 */
@SpringJUnitConfig(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
class AuctionFlowTest {

	@Autowired DataSource dataSource;
	@Autowired AuctMasterService service;
	@Autowired AuctionCloseService closeService;

	@BeforeEach
	void reset() {
		TestDb.reset(dataSource);
	}

	@Test
	void bidBelowMinimumIsRejected() {
		BusinessException e = assertThrows(BusinessException.class, () -> service.bid(2, 2, 200_000, 1));
		assertTrue(e.getMessage().contains("205,000"));
	}

	@Test
	void validBidRaisesPriceAndCount() {
		service.bid(2, 2, 205_000, 1);
		AuctMasterDTO p = service.getProduct(2);
		assertEquals(205_000, p.getStart_amt());
		assertEquals(1, p.getJoin_cnt());
		assertEquals(2, service.getTopBidderUnum(2));
	}

	@Test
	void sellerCannotBidOnOwnProduct() {
		assertThrows(BusinessException.class, () -> service.bid(2, 1, 300_000, 1));
	}

	@Test
	void cannotBidBeforeStartOrOverQuantity() {
		assertThrows(BusinessException.class, () -> service.bid(3, 2, 60_000, 1)); // 시작 전
		assertThrows(BusinessException.class, () -> service.bid(2, 2, 300_000, 3)); // 수량 2 초과
	}

	@Test
	void bidAtOrAboveBuyNowPriceMustUseBuyNow() {
		BusinessException e = assertThrows(BusinessException.class, () -> service.bid(1, 2, 600_000, 1));
		assertTrue(e.getMessage().contains("즉시구매"));
	}

	@Test
	void concurrentBidsAtSamePriceOnlyOneWins() throws Exception {
		ExecutorService pool = Executors.newFixedThreadPool(2);
		CountDownLatch start = new CountDownLatch(1);
		AtomicInteger ok = new AtomicInteger(), conflict = new AtomicInteger();
		Future<?> a = pool.submit(() -> race(start, 2, ok, conflict));
		Future<?> b = pool.submit(() -> race(start, 3, ok, conflict));
		start.countDown();
		a.get(10, TimeUnit.SECONDS);
		b.get(10, TimeUnit.SECONDS);
		pool.shutdown();

		assertEquals(1, ok.get(), "같은 현재가에서 동시에 입찰하면 한 명만 성공해야 함");
		assertEquals(1, conflict.get());
		assertEquals(1, service.getProduct(2).getJoin_cnt());
	}

	private void race(CountDownLatch start, int unum, AtomicInteger ok, AtomicInteger conflict) {
		try {
			start.await();
			service.bid(2, unum, 205_000, 1);
			ok.incrementAndGet();
		} catch (BusinessException e) {
			conflict.incrementAndGet();
		} catch (InterruptedException e) {
			Thread.currentThread().interrupt();
		}
	}

	@Test
	void buyNowEndsAuctionImmediately() {
		service.buyNow(1, 2, 1);
		AuctMasterDTO p = service.getProduct(1);
		assertEquals(AuctMasterDTO.END_BUY_NOW, p.getEnd_chk());
		assertEquals(2, p.getWin_unum());
		assertEquals(600_000, p.getWin_amt());
		assertEquals("ENDED", p.getAuct_status());

		// 이미 끝났으므로 입찰 · 즉시구매 모두 실패
		assertThrows(BusinessException.class, () -> service.bid(1, 3, 430_000, 1));
		assertThrows(BusinessException.class, () -> service.buyNow(1, 3, 1));
	}

	@Test
	void buyNowNotAllowedWhenDisabled() {
		assertThrows(BusinessException.class, () -> service.buyNow(2, 2, 1)); // 상품 2 는 즉시구매 없음
	}

	@Test
	void endedAuctionWithBidsIsSoldToHighestBidder() {
		assertTrue(closeService.closeIfEnded(5));
		AuctMasterDTO p = service.getProduct(5);
		assertEquals(AuctMasterDTO.END_SOLD, p.getEnd_chk());
		assertEquals(3, p.getWin_unum());
		assertEquals(64_000, p.getWin_amt());
		assertEquals("박입찰", p.getWin_name());
		assertEquals("박*찰", p.getWin_name_masked());

		assertFalse(closeService.closeIfEnded(5), "두 번 처리하지 않음");
	}

	@Test
	void endedAuctionWithoutBidsIsUnsold() {
		assertTrue(closeService.closeIfEnded(4));
		AuctMasterDTO p = service.getProduct(4);
		assertEquals(AuctMasterDTO.END_UNSOLD, p.getEnd_chk());
		assertNull(p.getWin_unum());
	}

	@Test
	void liveAuctionIsNotClosed() {
		assertFalse(closeService.closeIfEnded(2));
		assertEquals("N", service.getProduct(2).getEnd_chk());
	}

	@Test
	void viewingAnEndedAuctionClosesItRightAway() {
		// 스케줄러를 기다리지 않고 상세 조회 시점에 낙찰 처리
		assertEquals(AuctMasterDTO.END_SOLD, service.getProduct(5).getEnd_chk());
	}
}
