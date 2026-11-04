package com.myauct.web.domain.auctmaster.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.auctmaster.dto.SuggestDTO;
import com.myauct.web.domain.user.service.global.util.PagingDTO;

public interface AuctMasterDAO {

	List<AuctMasterDTO> getProductList(PagingDTO pagingDTO);

	AuctMasterDTO getProduct(int anum);

	Integer createProduct(AuctMasterDTO dto);

	Integer modifyProduct(AuctMasterDTO dto);

	Integer deleteProduct(int anum);

	Integer getProductCnt(@Param("value") String value);

	Integer getUserProductCnt(int unum);

	/**
	 * 검색 자동완성: 검색어가 들어간 상품명 · 카테고리.
	 * @param keyword LIKE 특수문자(% _ \)를 이스케이프한 검색어
	 */
	List<SuggestDTO> suggest(@Param("keyword") String keyword,
			@Param("limit") int limit);

	/**
	 * 현재가가 expectedAmt 일 때만 입찰가로 바꾼다 (동시에 두 명이 입찰해도 한 명만 성공).
	 * @return 바뀐 행 수 (0 이면 그 사이에 다른 사람이 먼저 입찰한 것)
	 */
	Integer updateBidAmt(@Param("anum") int anum, @Param("expectedAmt") int expectedAmt,
			@Param("bidAmt") int bidAmt);
}
