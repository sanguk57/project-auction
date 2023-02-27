package com.myauct.web.domain.auctmaster.dao;

import com.myauct.web.domain.auctmaster.dto.AuctMasterJoinDTO;

public interface AuctMasterJoinDAO {
    Integer auctionApplicant (AuctMasterJoinDTO auctMasterJoinDTO);
    
    Integer modifyApplicant(AuctMasterJoinDTO auctMasterJoinDTO);
    
    Integer getJoinCnt();


}
