package com.myauct.web.domain.auctboard.service;

import java.util.List;

import com.myauct.web.domain.auctboard.dto.AuctBoardMemoDTO;

public interface AuctBoardMemoService {
Integer CreateMemo(AuctBoardMemoDTO auctBoardMemoDTO); 
	
	List<AuctBoardMemoDTO> getMemoList(int qnum);
	
	Integer MemoCnt(int qnum);
}
