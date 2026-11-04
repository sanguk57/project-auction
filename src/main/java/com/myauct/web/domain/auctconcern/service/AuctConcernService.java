package com.myauct.web.domain.auctconcern.service;

import java.util.List;

public interface AuctConcernService {

	/** 이미 찜한 상품이면 아무것도 하지 않음 (예전에는 누를 때마다 중복 저장) */
	void addConcern(int anum, int unum);

	void removeConcern(int anum, int unum);

	/** 찜한 상품 번호 목록 */
	List<Integer> concernAnumList(int unum);

	int concernCnt(int unum);
}
