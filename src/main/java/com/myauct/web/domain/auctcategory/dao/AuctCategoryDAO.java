package com.myauct.web.domain.auctcategory.dao;

import java.util.List;

import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;

public interface AuctCategoryDAO {
	Integer registerCategory(AuctCategoryDTO auctCategoryDTO);

	Integer modifyCategory(AuctCategoryDTO auctCategoryDTO);

	/** 없으면 null (예전 int 반환형은 결과가 없을 때 예외 발생) */
	Integer getCnum(String category);

	String getCategory(int cnum);

	List<AuctCategoryDTO> getCategoryList();
}
