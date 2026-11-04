package com.myauct.web.domain.auctmaster.dto;

import lombok.Data;

@Data
public class AuctMasterJoinDTO {
	public static final String BID = "B", BUY_NOW = "L";

	/** amount: 수량, volume: 입찰 가격 */
	private int jnum, unum, anum, amount, volume;
	private String join_gb = BID;
	private String cancel_chk = "N";
	private String join_created;
}
