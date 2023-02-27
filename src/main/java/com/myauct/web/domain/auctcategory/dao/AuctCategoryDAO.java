package com.myauct.web.domain.auctcategory.dao;

import java.util.List;

import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;

public interface AuctCategoryDAO {
    Integer registerCategory(AuctCategoryDTO auctCategoryDTO);
    
    Integer modifyCategory(AuctCategoryDTO auctCategoryDTO);
    
    int getCnum(String category);
    
    String getCategory(int cnum);
    
    List<AuctCategoryDTO> getCategoryList();
}
