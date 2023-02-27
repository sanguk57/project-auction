package com.myauct.web.domain.auctboard.service;

import java.util.List;

import com.myauct.web.domain.auctboard.dto.AuctBoardDTO;

public interface AuctBoardService {
	Integer createBoard(AuctBoardDTO auctBoardDTO);
	
	List<AuctBoardDTO> boardList();
	
	Integer getBoardTotal();
	
	Integer userBoardCnt(int unum);
}
