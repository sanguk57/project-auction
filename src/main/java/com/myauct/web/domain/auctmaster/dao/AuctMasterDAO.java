package com.myauct.web.domain.auctmaster.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.auctmaster.dto.SuggestDTO;
import com.myauct.web.domain.user.service.global.util.PagingDTO;

public interface AuctMasterDAO {

	/** 목록 (검색 · 상태 · 카테고리 필터, 정렬, 페이징) */
	List<AuctMasterDTO> getProductList(PagingDTO pagingDTO);

	/** getProductList 와 같은 조건의 전체 개수 (페이지 수 계산용) */
	Integer countProductList(PagingDTO pagingDTO);

	/** 상세 (카테고리 이름, 낙찰자 이름 포함) */
	AuctMasterDTO getProduct(int anum);

	/** 마감 처리할 때 다른 입찰과 겹치지 않도록 행을 잠그고 읽는다 (SELECT ... FOR UPDATE) */
	AuctMasterDTO lockProduct(int anum);

	Integer createProduct(AuctMasterDTO dto);

	Integer modifyProduct(AuctMasterDTO dto);

	Integer deleteProduct(int anum);

	/** 메인 화면 "전체 경매 N" (검색어 기준) */
	Integer getProductCnt(@Param("value") String value);

	Integer getUserProductCnt(int unum);

	/**
	 * 검색 자동완성: 검색어가 들어간 상품명 · 카테고리.
	 * @param keyword LIKE 특수문자(% _ \)를 이스케이프한 검색어
	 */
	List<SuggestDTO> suggest(@Param("keyword") String keyword, @Param("limit") int limit);

	/**
	 * 현재가가 expectedAmt 이고 아직 마감 처리 전일 때만 입찰가로 바꾼다
	 * (동시에 두 명이 입찰해도 한 명만 성공, 마감된 뒤에는 실패).
	 * @return 바뀐 행 수 (0 이면 그 사이에 다른 사람이 먼저 입찰했거나 마감됨)
	 */
	Integer updateBidAmt(@Param("anum") int anum, @Param("expectedAmt") int expectedAmt,
			@Param("bidAmt") int bidAmt);

	/** 즉시구매: 즉시구매가 켜져 있고 마감 전일 때만 즉시구매가로 낙찰 처리. @return 바뀐 행 수 */
	Integer buyNow(@Param("anum") int anum, @Param("unum") int unum);

	/** 마감 시간이 지났는데 아직 낙찰/유찰 처리가 안 된 상품 번호 */
	List<Integer> findCloseTargets();

	/** 낙찰(S) 또는 유찰(U) 처리. 아직 처리 전(end_chk = N)일 때만 바뀐다. @return 바뀐 행 수 */
	Integer closeProduct(@Param("anum") int anum, @Param("endChk") String endChk,
			@Param("winUnum") Integer winUnum, @Param("winAmt") Integer winAmt);
}
