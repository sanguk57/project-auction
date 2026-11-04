package com.myauct.web.domain.auctmaster.dto;

import java.sql.Date;

import com.myauct.web.global.AuctionTime;

import lombok.Data;

@Data
public class AuctMasterDTO {
	private int anum, unum, cnum, limit_amt, join_amt, join_cnt, curr_amt, total_cnt, start_amt;
	private String sales_addr, prod_name, auct_start, auct_end, prod_img, contents, prod_title;
	/** Y / N 값. char 로 두면 JSP(EL)에서 'N' 과 비교할 때 숫자로 변환하려다 오류가 난다 */
	private String prod_type, as_type, limit_type, trans_type, con_html, end_chk, delete_chk;
	private Date reg_date;

	/** 조회용: 카테고리 이름 (목록 쿼리에서 함께 가져옴) */
	private String category;
	/** 조회용: 첫 번째 썸네일 경로 (/web/upload/ 뒤에 붙임), 이미지가 없으면 null */
	private String thumb;

	/** READY(시작 전) / LIVE(진행 중) / ENDED(마감) */
	public String getAuct_status() {
		return AuctionTime.status(auct_start, auct_end);
	}

	/** "3일 남음", "11.10 09:00 시작", "마감" */
	public String getTime_label() {
		return AuctionTime.label(auct_start, auct_end);
	}

	/** 다음 입찰 최소 금액 (서비스의 입찰 검사와 같은 규칙) */
	public int getMin_bid() {
		return start_amt + Math.max(join_amt, 1);
	}
}
