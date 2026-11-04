package com.myauct.web.domain.auctmaster.service;

import java.time.LocalDateTime;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.myauct.web.domain.auctmaster.dao.AuctMasterDAO;
import com.myauct.web.domain.auctmaster.dao.AuctMasterJoinDAO;
import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.auctmaster.dto.AuctMasterJoinDTO;
import com.myauct.web.domain.user.dao.UserDAO;
import com.myauct.web.global.AuctionTime;

import lombok.RequiredArgsConstructor;

/**
 * 마감 시간이 지난 경매를 낙찰(최고 입찰자) 또는 유찰(입찰 없음)로 확정한다.
 *
 * 동시성: 마감 처리는 상품 행을 먼저 잠그고(SELECT ... FOR UPDATE) 최고 입찰을 읽는다.
 *  - 직전에 들어온 입찰이 있으면 그 입찰의 커밋을 기다렸다가 반영한다.
 *  - 잠근 뒤에 들어오는 입찰은 end_chk = 'N' 조건 때문에 실패한다.
 */
@Service
@RequiredArgsConstructor
public class AuctionCloseService {

	private static final Logger logger = LoggerFactory.getLogger(AuctionCloseService.class);

	private final AuctMasterDAO auctMasterDAO;
	private final AuctMasterJoinDAO auctMasterJoinDAO;
	private final UserDAO userDAO;
	private final AuctionEventHub eventHub;

	/**
	 * 마감 시간이 지났으면 낙찰/유찰 처리. 이미 처리됐거나 아직 진행 중이면 아무것도 하지 않는다.
	 * @return 이번에 처리했으면 true
	 */
	@Transactional
	public boolean closeIfEnded(int anum) {
		AuctMasterDTO p = auctMasterDAO.lockProduct(anum);
		if (p == null || p.isClosed()) {
			return false;
		}
		LocalDateTime end = AuctionTime.parse(p.getAuct_end());
		if (end == null || LocalDateTime.now().isBefore(end)) {
			return false;
		}

		AuctMasterJoinDTO top = auctMasterJoinDAO.topBid(anum);
		boolean sold = top != null;
		auctMasterDAO.closeProduct(anum, sold ? AuctMasterDTO.END_SOLD : AuctMasterDTO.END_UNSOLD,
				sold ? top.getUnum() : null, sold ? top.getVolume() : null);

		AuctMasterDTO closed = auctMasterDAO.getProduct(anum);
		eventHub.publishAfterCommit(new AuctionEventHub.AuctionEvent("close", closed,
				sold ? userDAO.getName(top.getUnum()) : null));
		logger.info("경매 마감: anum={} → {}", anum, sold ? "낙찰 unum=" + top.getUnum() + ", " + top.getVolume() + "원" : "유찰");
		return true;
	}
}
