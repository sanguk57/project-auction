package com.myauct.web.domain.auctmaster.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.user.service.global.util.PagingDTO;

public interface AuctMasterService {
	   List<AuctMasterDTO> getProductList(PagingDTO pagingDTO);
	   
	   AuctMasterDTO getProduct(int anum);
	   
	   Integer moidfyProduct(AuctMasterDTO dto);
	   
	   Integer deleteProduct(int anum);
	   
	   Integer createProduct(AuctMasterDTO dto);
	   
	   Integer getProductCnt(String value); 
	   
	   Integer getUserProductCnt(int unum); 
	   
	   Integer getProductAmt(int anum);
	   
	   Integer modifyProductAmt(@Param("start_amt") int strat_amt, @Param("anum") int anum, @Param("join_cnt") int join_cnt);
}
