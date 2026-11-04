package com.myauct.web.domain.mypage.dto;

import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/** 마이페이지 목록 한 줄: 상품 정보 + 내 입찰 정보 + 상대방(판매자 또는 낙찰자) 연락처 */
@Data
@EqualsAndHashCode(callSuper = true)
public class MyAuctionDTO extends AuctMasterDTO {
	/** 내가 넣은 최고 입찰가 / 입찰 횟수 / 마지막 입찰 시각 (입찰 내역 탭) */
	private int my_max, my_cnt;
	private String last_bid;

	/** 상대방 연락처 (낙찰 받은 상품 → 판매자, 판매 현황 → 낙찰자) */
	private String other_name, other_phone, other_email;

	/** 화면에서 상태를 계산할 때 쓰는 "나" */
	private int viewer_unum;

	/**
	 * 입찰 내역에서의 내 상태
	 *  WON 낙찰 / LOST 패찰 / TOP 최고 입찰 중 / OUTBID 추월됨
	 */
	public String getMy_status() {
		if (isClosed() || "ENDED".equals(getAuct_status())) {
			return getWin_unum() != null && getWin_unum() == viewer_unum ? "WON" : "LOST";
		}
		return my_max >= getStart_amt() ? "TOP" : "OUTBID";
	}
}
