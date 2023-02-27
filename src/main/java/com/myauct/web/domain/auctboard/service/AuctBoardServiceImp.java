package com.myauct.web.domain.auctboard.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.myauct.web.domain.auctboard.dao.AuctBoardDAO;
import com.myauct.web.domain.auctboard.dto.AuctBoardDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuctBoardServiceImp implements AuctBoardService{
	
	final private AuctBoardDAO auctBoardDAO;
	
	@Override
	public Integer createBoard(AuctBoardDTO auctBoardDTO) {
		return auctBoardDAO.createBoard(auctBoardDTO); 
	}

	@Override
	public List<AuctBoardDTO> boardList() {
		return auctBoardDAO.boardList();
	}

	@Override
	public Integer getBoardTotal() {
		return auctBoardDAO.getBoardTotal();
	}

	@Override
	public Integer userBoardCnt(int unum) {
		return auctBoardDAO.userBoardCnt(unum);
	}
    
}
