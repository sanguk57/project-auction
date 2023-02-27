package com.myauct.web.aucttest;

import javax.inject.Inject;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;
import com.myauct.web.domain.auctcategory.service.AuctCategoryService;
import com.myauct.web.domain.auctmaster.service.AuctMasterService;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class AuctTests {
	 
	 @Inject
	 	private AuctCategoryService auctCategoryService;
	 @Inject
	 	private AuctMasterService auctMasterService;
	 
	 @Test
	 public void registerProduct() {
		 AuctCategoryDTO auctCategoryDTO = new AuctCategoryDTO();
		 
		 log.info("---- registerCategory() 호출 ----");
		 auctCategoryDTO.setCategory("가전기기");
		 
		 auctCategoryService.registerCategory(auctCategoryDTO);
	 }
	 
	 @Test
	 public void getProductList() {
		 auctMasterService.getProduct(5);
	 }
	
}
