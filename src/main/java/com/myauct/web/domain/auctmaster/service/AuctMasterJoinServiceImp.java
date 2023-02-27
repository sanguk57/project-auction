package com.myauct.web.domain.auctmaster.service;

import org.springframework.stereotype.Service;

import com.myauct.web.domain.auctmaster.dao.AuctMasterJoinDAO;
import com.myauct.web.domain.auctmaster.dto.AuctMasterJoinDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuctMasterJoinServiceImp  implements AuctMasterJoinService{
	final private AuctMasterJoinDAO auctMasterJoinDAOJoinDAO;
	@Override
	public Integer auctionApplicant(AuctMasterJoinDTO auctMasterJoinDTO) {
		return auctMasterJoinDAOJoinDAO.auctionApplicant(auctMasterJoinDTO);
	}

	@Override
	public Integer modifyApplicant(AuctMasterJoinDTO auctMasterJoinDTO) {
		return auctMasterJoinDAOJoinDAO.modifyApplicant(auctMasterJoinDTO);
	}

	@Override
	public Integer getJoinCnt() {
		return auctMasterJoinDAOJoinDAO.getJoinCnt();
	}
	
	
    
}
