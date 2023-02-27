package com.myauct.web.domain.auctmaster.service;

import com.myauct.web.domain.auctmaster.dto.AuctMasterJoinDTO;

public interface AuctMasterJoinService {
	  Integer auctionApplicant (AuctMasterJoinDTO auctMasterJoinDTO);
	    
	    Integer modifyApplicant(AuctMasterJoinDTO auctMasterJoinDTO);
	    
	    Integer getJoinCnt();
}
