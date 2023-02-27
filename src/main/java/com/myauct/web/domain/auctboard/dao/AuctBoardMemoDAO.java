package com.myauct.web.domain.auctboard.dao;

import java.util.List;

import com.myauct.web.domain.auctboard.dto.AuctBoardMemoDTO;

public interface AuctBoardMemoDAO {
	Integer CreateMemo(AuctBoardMemoDTO auctBoardMemoDTO); 
	
	List<AuctBoardMemoDTO> getMemoList(int qnum);
	
	Integer MemoCnt(int qnum);

}
