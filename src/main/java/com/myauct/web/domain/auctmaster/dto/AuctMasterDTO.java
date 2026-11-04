package com.myauct.web.domain.auctmaster.dto;

import java.sql.Date;

import com.myauct.web.global.AuctionTime;

import lombok.Data;

@Data
public class AuctMasterDTO {
	/** end_chk 값 */
	public static final String END_NONE = "N", END_SOLD = "S", END_UNSOLD = "U", END_BUY_NOW = "B";

	private int anum, unum, cnum, limit_amt, join_amt, join_cnt, curr_amt, total_cnt, start_amt;
	private String sales_addr, prod_name, auct_start, auct_end, prod_img, contents, prod_title;
	/** Y / N 값. char 로 두면 JSP(EL)에서 'N' 과 비교할 때 숫자로 변환하려다 오류가 난다 */
	private String prod_type, as_type, limit_type, trans_type, con_html, end_chk, delete_chk;
	private Date reg_date;

	/** 낙찰자 회원번호 / 낙찰가 / 낙찰·유찰 처리 시각 (end_chk 가 S 또는 B 일 때) */
	private Integer win_unum, win_amt;
	private String end_date;

	/** 조회용: 카테고리 이름 (목록 쿼리에서 함께 가져옴) */
	private String category;
	/** 조회용: 첫 번째 썸네일 경로 (/web/upload/ 뒤에 붙임), 이미지가 없으면 null */
	private String thumb;
	/** 조회용: 낙찰자 이름 (상세 화면에서 가려서 보여줌) */
	private String win_name;

	/** 마감 처리가 끝났는지 (낙찰 · 유찰 · 즉시구매) */
	public boolean isClosed() {
		return end_chk != null && !END_NONE.equals(end_chk);
	}

	/** READY(시작 전) / LIVE(진행 중) / ENDED(마감 시간이 지났거나 낙찰 · 유찰 · 즉시구매로 끝남) */
	public String getAuct_status() {
		return isClosed() ? AuctionTime.ENDED : AuctionTime.status(auct_start, auct_end);
	}

	/** "3일 남음", "11.10 09:00 시작", "낙찰", "유찰", "즉시구매 완료", "마감" */
	public String getTime_label() {
		if (END_SOLD.equals(end_chk)) return "낙찰";
		if (END_UNSOLD.equals(end_chk)) return "유찰";
		if (END_BUY_NOW.equals(end_chk)) return "즉시구매 완료";
		return AuctionTime.label(auct_start, auct_end);
	}

	/** 다음 입찰 최소 금액 (서비스의 입찰 검사와 같은 규칙) */
	public int getMin_bid() {
		return start_amt + Math.max(join_amt, 1);
	}

	/** 즉시구매가 켜져 있는지 */
	public boolean isBuyNowEnabled() {
		return "Y".equals(limit_type) && limit_amt > 0;
	}

	/** 즉시구매가 이상으로는 입찰할 수 없으므로, 입찰 가능한 금액이 남아 있는지 */
	public boolean isBidPossible() {
		return !isBuyNowEnabled() || getMin_bid() < limit_amt;
	}

	/** 이름 가리기: 홍길동 → 홍*동, 김철 → 김*, Kim Chulsoo → K********** */
	public static String mask(String name) {
		if (name == null || name.isEmpty()) return "";
		if (name.length() == 1) return name;
		if (name.length() == 2) return name.charAt(0) + "*";
		StringBuilder sb = new StringBuilder().append(name.charAt(0));
		for (int i = 1; i < name.length() - 1; i++) sb.append('*');
		return sb.append(name.charAt(name.length() - 1)).toString();
	}

	public String getWin_name_masked() {
		return mask(win_name);
	}
}
