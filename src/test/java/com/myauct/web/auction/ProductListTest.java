package com.myauct.web.auction;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;
import java.util.stream.Collectors;

import javax.sql.DataSource;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.auctmaster.service.AuctMasterService;
import com.myauct.web.domain.user.service.global.util.PagingDTO;
import com.myauct.web.support.TestDb;

/** 목록 필터(상태 · 카테고리 · 검색 · 내 상품 · 관심 상품)와 정렬, 개수가 목록과 맞는지 */
@SpringJUnitConfig(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
class ProductListTest {

	@Autowired DataSource dataSource;
	@Autowired AuctMasterService service;

	@BeforeEach
	void reset() {
		TestDb.reset(dataSource);
	}

	private List<Integer> list(String value, String key, int unum, String sort, String status, int cnum) {
		PagingDTO filter = PagingDTO.filter(value, key, unum, sort, status, cnum);
		int total = service.countProductList(filter);
		PagingDTO page = new PagingDTO(total, 1, 50, value, key, unum).withFiltersOf(filter);
		List<Integer> anums = service.getProductList(page).stream().map(AuctMasterDTO::getAnum).collect(Collectors.toList());
		assertEquals(total, anums.size(), "개수와 목록이 같은 조건이어야 함");
		return anums;
	}

	@Test
	void statusFilter() {
		assertEquals(List.of(2, 1), list("", null, 0, "ending", "live", 0)); // 마감이 가까운 순
		assertEquals(List.of(3), list("", null, 0, "ending", "ready", 0));
		assertEquals(2, list("", null, 0, "ending", "ended", 0).size()); // 4, 5
		assertEquals(5, list("", null, 0, "ending", "all", 0).size());
	}

	@Test
	void defaultOrderIsLiveThenReadyThenEnded() {
		List<Integer> all = list("", null, 0, "ending", "all", 0);
		assertEquals(List.of(2, 1, 3), all.subList(0, 3));
	}

	@Test
	void sortOptions() {
		assertEquals(4, list("", null, 0, "price_asc", "all", 0).get(0));  // 15,000
		assertEquals(1, list("", null, 0, "price_desc", "all", 0).get(0)); // 420,000
		assertEquals(5, list("", null, 0, "new", "all", 0).get(0));
		assertEquals(5, list("", null, 0, "bids", "all", 0).get(0));       // 입찰 3건
	}

	@Test
	void categoryAndSearch() {
		assertEquals(List.of(2, 5), list("", null, 0, "new", "all", 1).stream().sorted().collect(Collectors.toList())); // 가전기기
		assertEquals(List.of(3), list("패딩", null, 0, "ending", "all", 0));
		assertEquals(List.of(1), list("디지털", null, 0, "ending", "all", 0)); // 카테고리 이름 검색
	}

	@Test
	void myProductsAndConcerns() {
		assertEquals(5, list("", "A", 1, "ending", "all", 0).size()); // seller01 이 등록한 상품
		assertEquals(List.of(2, 1), list("", "B", 2, "ending", "all", 0)); // buyer001 이 찜한 상품
		assertEquals(List.of(1), list("", "B", 2, "ending", "all", 2)); // 찜 + 카테고리
	}

	@Test
	void invalidSortOrStatusFallsBackToDefault() {
		PagingDTO p = PagingDTO.filter("", null, 0, "'; drop table x; --", "nope", 0);
		assertEquals("ending", p.getSort());
		assertEquals("all", p.getStatus());
	}
}
