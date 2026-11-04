package com.myauct.web.domain.auctcategory.service;

import java.util.List;

import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;

public interface AuctCategoryService {

	/**
	 * 화면에서 고른 카테고리 번호를 돌려준다.
	 * 번호가 없으면(직접 입력) 같은 이름이 있는지 찾아보고, 없을 때만 새로 만든다.
	 */
	int resolveCnum(AuctCategoryDTO categoryDTO);

	List<AuctCategoryDTO> getCategoryList();

	String getCategory(int cnum);
}
