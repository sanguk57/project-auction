package com.myauct.web.domain.auctboard.dao;

import java.util.List;

import com.myauct.web.domain.auctboard.dto.AuctBoardDTO;

public interface AuctBoardDAO {

	Integer createBoard(AuctBoardDTO auctBoardDTO);

	/** 해당 상품의 댓글 (작성자 이름, 답글 수 포함) */
	List<AuctBoardDTO> boardList(int anum);

	Integer userBoardCnt(int unum);

	Integer existsBoard(int qnum);
}
