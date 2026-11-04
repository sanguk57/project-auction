package com.myauct.web.domain.auctmaster.dao;

import com.myauct.web.domain.auctmaster.dto.AuctMasterJoinDTO;

public interface AuctMasterJoinDAO {
	/** 입찰 / 즉시구매 기록 (join_gb: B 입찰, L 즉시구매) */
	Integer auctionApplicant(AuctMasterJoinDTO auctMasterJoinDTO);

	/** 최고 입찰 (가격이 같으면 먼저 입찰한 사람). 입찰이 없으면 null */
	AuctMasterJoinDTO topBid(int anum);
}
