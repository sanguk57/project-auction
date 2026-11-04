package com.myauct.web.domain.auctboard.dto;

import lombok.Data;

@Data
public class AuctBoardMemoDTO {
	private int mnum, qnum, unum;
	private String memo, wdate;

	/** 조회용: 작성자 이름 */
	private String name;
}
