package com.myauct.web.domain.auctboard.dao;

import java.util.List;

import com.myauct.web.domain.auctboard.dto.AuctBoardDTO;

public interface AuctBoardDAO {

	Integer createBoard(AuctBoardDTO auctBoardDTO);
	
	List<AuctBoardDTO> boardList();
	
	Integer getBoardTotal();
	
	Integer userBoardCnt(int unum);
}
