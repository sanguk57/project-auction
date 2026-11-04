package com.myauct.web.domain.auctboard.dto;

import lombok.Data;

@Data
public class AuctBoardDTO {
	private int qnum, unum, anum, re_cnt, views;
	private String subject, contents, wdate;

	/** 조회용: 작성자 이름 */
	private String name;
	/** 조회용: 답글 개수 */
	private int memo_cnt;
}
