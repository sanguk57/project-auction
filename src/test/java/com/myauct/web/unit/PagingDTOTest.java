package com.myauct.web.unit;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

import com.myauct.web.domain.user.service.global.util.PagingDTO;

/** DB 없이 실행되는 단위 테스트 */
public class PagingDTOTest {

	@Test
	public void offsetForSecondPage() {
		PagingDTO p = new PagingDTO(30, 2, 4, "", null, 0);
		assertEquals(4, p.getOffset());
		assertEquals(8, p.getLastPage());
	}

	@Test
	public void clampsBadInput() {
		PagingDTO p = new PagingDTO(30, -5, 100000, "", null, 0);
		assertEquals(1, p.getNowPage());
		assertEquals(50, p.getCntPerPage());
		assertEquals(0, p.getOffset());
	}
}
