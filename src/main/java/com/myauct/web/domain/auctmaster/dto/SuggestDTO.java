package com.myauct.web.domain.auctmaster.dto;

import lombok.Data;

/** 검색창 자동완성 항목 */
@Data
public class SuggestDTO {
	/** 추천 검색어 (상품명 또는 카테고리 이름) */
	private String keyword;
	/** "상품" 또는 "카테고리" */
	private String type;
	/** 이 검색어로 찾을 수 있는 상품 수 */
	private int cnt;
}
