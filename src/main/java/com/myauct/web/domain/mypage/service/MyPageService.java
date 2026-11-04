package com.myauct.web.domain.mypage.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.myauct.web.domain.mypage.dao.MyPageDAO;
import com.myauct.web.domain.mypage.dto.MyAuctionDTO;
import com.myauct.web.domain.user.dao.UserDAO;
import com.myauct.web.domain.user.service.UserService;
import com.myauct.web.global.BusinessException;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MyPageService {

	private final MyPageDAO myPageDAO;
	private final UserDAO userDAO;
	private final UserService userService;

	public List<MyAuctionDTO> myBids(int unum) {
		List<MyAuctionDTO> list = myPageDAO.myBids(unum);
		list.forEach(d -> d.setViewer_unum(unum));
		return list;
	}

	public List<MyAuctionDTO> myWins(int unum) {
		return myPageDAO.myWins(unum);
	}

	public List<MyAuctionDTO> mySales(int unum) {
		return myPageDAO.mySales(unum);
	}

	/**
	 * 회원 탈퇴. 진행 중인 판매가 있거나 지금 1등으로 입찰 중이면 거래 상대가 생길 수 있으므로 막는다.
	 * 입찰 · 낙찰 기록은 남기고 개인정보만 지운다.
	 */
	@Transactional
	public void withdraw(int unum, String password) {
		if (!userService.checkPassword(unum, password)) {
			throw BusinessException.badRequest("비밀번호가 맞지 않습니다.");
		}
		if (myPageDAO.countOpenSales(unum) > 0) {
			throw BusinessException.badRequest("진행 중이거나 시작 전인 판매 상품이 있어 탈퇴할 수 없습니다. 상품을 삭제하거나 경매가 끝난 뒤 탈퇴해주세요.");
		}
		if (myPageDAO.countLeadingBids(unum) > 0) {
			throw BusinessException.badRequest("최고 입찰자로 참여 중인 경매가 있어 탈퇴할 수 없습니다. 경매가 끝난 뒤 탈퇴해주세요.");
		}
		myPageDAO.deleteConcerns(unum);
		userDAO.withdraw(unum);
	}
}
