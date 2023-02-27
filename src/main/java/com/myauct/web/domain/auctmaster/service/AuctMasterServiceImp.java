package com.myauct.web.domain.auctmaster.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.myauct.web.domain.auctmaster.dao.AuctMasterDAO;
import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.user.service.global.util.PagingDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class AuctMasterServiceImp implements AuctMasterService{
	
	final private AuctMasterDAO auctMasterdao;
	
	@Override
	public List<AuctMasterDTO> getProductList(PagingDTO pagingDTO) {
		return auctMasterdao.getProductList(pagingDTO);
	}

	@Override
	public AuctMasterDTO getProduct(int anum) {
		return auctMasterdao.getProduct(anum);
	}

	@Override
	public Integer moidfyProduct(AuctMasterDTO dto) {
		return auctMasterdao.moidfyProduct(dto);
	}

	@Override
	public Integer deleteProduct(int anum) {
		return auctMasterdao.deleteProduct(anum);
	}

	@Override
	public Integer createProduct(AuctMasterDTO dto) {
		return auctMasterdao.createProduct(dto);
	}

	@Override
	public Integer getProductCnt(String value) {
		return auctMasterdao.getProductCnt(value);
	}

	@Override
	public Integer getUserProductCnt(int unum) {
		return auctMasterdao.getUserProductCnt(unum);
	}

	@Override
	public Integer getProductAmt(int anum) {
		return auctMasterdao.getProductAmt(anum);
	}

	@Override
	public Integer modifyProductAmt(int start_amt, int anum, int join_cnt) {
		return auctMasterdao.modifyProductAmt(start_amt, anum, join_cnt);
	}
	
}
