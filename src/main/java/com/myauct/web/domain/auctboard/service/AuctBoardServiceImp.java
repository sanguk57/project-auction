package com.myauct.web.domain.auctboard.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.myauct.web.domain.auctboard.dao.AuctBoardDAO;
import com.myauct.web.domain.auctboard.dao.AuctBoardMemoDAO;
import com.myauct.web.domain.auctboard.dto.AuctBoardDTO;
import com.myauct.web.domain.auctboard.dto.AuctBoardMemoDTO;
import com.myauct.web.domain.auctmaster.service.AuctMasterService;
import com.myauct.web.global.BusinessException;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuctBoardServiceImp implements AuctBoardService {

	private static final int MAX_SUBJECT = 100;
	private static final int MAX_CONTENTS = 1000;

	private final AuctBoardDAO auctBoardDAO;
	private final AuctBoardMemoDAO auctBoardMemoDAO;
	private final AuctMasterService auctMasterService;

	@Override
	public void createBoard(int anum, int loginUnum, String subject, String contents) {
		auctMasterService.getProduct(anum); // 없는 상품이면 예외
		AuctBoardDTO dto = new AuctBoardDTO();
		dto.setAnum(anum);
		dto.setUnum(loginUnum);
		dto.setSubject(requireText(subject, MAX_SUBJECT, "제목"));
		dto.setContents(requireText(contents, MAX_CONTENTS, "내용"));
		auctBoardDAO.createBoard(dto);
	}

	@Override
	public List<AuctBoardDTO> boardList(int anum) {
		return auctBoardDAO.boardList(anum);
	}

	@Override
	public int userBoardCnt(int unum) {
		return auctBoardDAO.userBoardCnt(unum);
	}

	@Override
	public void createMemo(int qnum, int loginUnum, String memo) {
		Integer exists = auctBoardDAO.existsBoard(qnum);
		if (exists == null || exists == 0) {
			throw BusinessException.badRequest("존재하지 않는 댓글입니다.");
		}
		AuctBoardMemoDTO dto = new AuctBoardMemoDTO();
		dto.setQnum(qnum);
		dto.setUnum(loginUnum);
		dto.setMemo(requireText(memo, MAX_CONTENTS, "답글"));
		auctBoardMemoDAO.createMemo(dto);
	}

	@Override
	public List<AuctBoardMemoDTO> getMemoList(int qnum) {
		return auctBoardMemoDAO.getMemoList(qnum);
	}

	private static String requireText(String value, int maxLength, String label) {
		String v = value == null ? "" : value.trim();
		if (v.isEmpty()) {
			throw BusinessException.badRequest(label + "을(를) 입력해주세요.");
		}
		if (v.length() > maxLength) {
			throw BusinessException.badRequest(label + "은(는) " + maxLength + "자까지 입력할 수 있습니다.");
		}
		return v;
	}
}
