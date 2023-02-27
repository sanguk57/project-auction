package com.myauct.web.domain.auctboard.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.myauct.web.domain.auctboard.dao.AuctBoardMemoDAO;
import com.myauct.web.domain.auctboard.dto.AuctBoardMemoDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuctBoardMemoServiceImp implements AuctBoardMemoService{
	
    final private AuctBoardMemoDAO auctBoardMemoDAO;

	@Override
	public Integer CreateMemo(AuctBoardMemoDTO auctBoardMemoDTO) {
		return auctBoardMemoDAO.CreateMemo(auctBoardMemoDTO);
	}

	@Override
	public List<AuctBoardMemoDTO> getMemoList(int qnum) {
		return auctBoardMemoDAO.getMemoList(qnum);
	}

	@Override
	public Integer MemoCnt(int qnum) {
		return auctBoardMemoDAO.MemoCnt(qnum);
	}
}
