package com.myauct.web.aucttest;

import org.springframework.beans.factory.annotation.Autowired;

import org.junit.jupiter.api.Test;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;
import com.myauct.web.domain.auctcategory.service.AuctCategoryService;
import com.myauct.web.domain.auctmaster.service.AuctMasterService;

import lombok.extern.slf4j.Slf4j;

/** DB 연결이 필요한 테스트 (로컬 MySQL + C:/myauct/app.properties 필요) */
@SpringJUnitConfig(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Slf4j
public class AuctTests {

	@Autowired
	private AuctCategoryService auctCategoryService;
	@Autowired
	private AuctMasterService auctMasterService;

	@Test
	public void resolveCategory() {
		AuctCategoryDTO dto = new AuctCategoryDTO();
		dto.setCategory("가전기기");
		// 같은 이름이면 두 번 호출해도 같은 번호 (예전에는 매번 새로 만들었음)
		int first = auctCategoryService.resolveCnum(dto);
		int second = auctCategoryService.resolveCnum(dto);
		log.info("cnum = {}, {}", first, second);
		org.junit.jupiter.api.Assertions.assertEquals(first, second);
	}

	@Test
	public void getProduct() {
		log.info("{}", auctMasterService.getProduct(5));
	}
}
