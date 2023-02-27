package com.myauct.web.domain.auctconcern.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.myauct.web.domain.auctconcern.dao.AuctConcernDAO;
import com.myauct.web.domain.auctconcern.dto.AuctConcernDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuctConcernServiceImp implements AuctConcernService{
	final private AuctConcernDAO auctConcernDAO;
	@Override
	public Integer createConcnern(AuctConcernDTO auctConcernDTO) {
		return auctConcernDAO.createConcnern(auctConcernDTO);
	}

	@Override
	public Integer deleteConcnern(int anum, int unum) {
		return auctConcernDAO.deleteConcnern(anum, unum);
	}

	@Override
	public List<AuctConcernDTO> concernList(int unum) {
		return auctConcernDAO.concernList(unum);
	}

	@Override
	public Integer concernCnt(int unum) {
		return auctConcernDAO.concernCnt(unum);
	}
	
    
}
