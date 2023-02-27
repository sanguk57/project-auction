package com.myauct.web.domain.auctcategory.service;

import java.util.List;

import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;

public interface AuctCategoryService {
	   Integer registerCategory(AuctCategoryDTO auctCategoryDTO);
	    
	    Integer modifyCategory(AuctCategoryDTO auctCategoryDTO);
	    
	    int getCnum(String category);
	    
	    List<AuctCategoryDTO> getCategoryList();
	    
	    String getCategory(int cnum);
}
