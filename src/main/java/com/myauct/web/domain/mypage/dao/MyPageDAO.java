package com.myauct.web.domain.mypage.dao;

import java.util.List;

import com.myauct.web.domain.mypage.dto.MyAuctionDTO;

public interface MyPageDAO {
	/** 내가 입찰한 상품 (상품마다 한 줄, 최근 입찰 순) */
	List<MyAuctionDTO> myBids(int unum);

	/** 내가 낙찰받은 상품 + 판매자 연락처 */
	List<MyAuctionDTO> myWins(int unum);

	/** 내가 등록한 상품 + 낙찰자 연락처 */
	List<MyAuctionDTO> mySales(int unum);

	/** 아직 끝나지 않은 내 판매 상품 수 (탈퇴 가능 여부) */
	int countOpenSales(int unum);

	/** 내가 지금 최고 입찰자인 진행 중 경매 수 (탈퇴 가능 여부) */
	int countLeadingBids(int unum);

	/** 탈퇴할 때 찜 목록 정리 */
	int deleteConcerns(int unum);
}
