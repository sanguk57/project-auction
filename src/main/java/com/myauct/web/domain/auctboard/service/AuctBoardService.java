package com.myauct.web.domain.auctboard.service;

import java.util.List;

import com.myauct.web.domain.auctboard.dto.AuctBoardDTO;
import com.myauct.web.domain.auctboard.dto.AuctBoardMemoDTO;

/** 상품 문의 댓글(Board) + 답글(Memo) */
public interface AuctBoardService {

	void createBoard(int anum, int loginUnum, String subject, String contents);

	List<AuctBoardDTO> boardList(int anum);

	int userBoardCnt(int unum);

	void createMemo(int qnum, int loginUnum, String memo);

	List<AuctBoardMemoDTO> getMemoList(int qnum);
}
