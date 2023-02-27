package com.myauct.web.domain.auctcategory.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.myauct.web.domain.auctcategory.dao.AuctCategoryDAO;
import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuctCategoryServiceImp implements AuctCategoryService{
	private static final Logger logger = LoggerFactory.getLogger(AuctCategoryServiceImp.class);
	
    final private AuctCategoryDAO auctCategorydao;

	@Override
	public Integer registerCategory(AuctCategoryDTO auctCategoryDTO) {
		
		return auctCategorydao.registerCategory(auctCategoryDTO);
	}

	@Override
	public Integer modifyCategory(AuctCategoryDTO auctCategoryDTO) {
		
		return auctCategorydao.modifyCategory(auctCategoryDTO);
	}

	@Override
	public int getCnum(String category) {
		return auctCategorydao.getCnum(category);
	}

	@Override
	public List<AuctCategoryDTO> getCategoryList() {
		return auctCategorydao.getCategoryList();
	}

	@Override
	public String getCategory(int cnum) {
		return auctCategorydao.getCategory(cnum);
	}
 
	
}
