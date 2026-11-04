package com.myauct.web.domain.auctmaster.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.myauct.web.domain.auctmaster.dao.AuctMasterDAO;

import lombok.RequiredArgsConstructor;

/**
 * 30초마다 마감 시간이 지난 경매를 찾아 낙찰/유찰 처리한다.
 * (상세 화면을 열 때도 바로 확인하므로, 보는 사람에게는 늦어도 화면을 여는 순간 반영된다)
 */
@Component
@RequiredArgsConstructor
public class AuctionCloseScheduler {

	private static final Logger logger = LoggerFactory.getLogger(AuctionCloseScheduler.class);

	private final AuctMasterDAO auctMasterDAO;
	private final AuctionCloseService closeService;

	/** 테스트에서는 끈다 (테스트가 확인하는 도중에 뒤에서 마감 처리되지 않도록) */
	@Value("${auction.closer.enabled:true}")
	private boolean enabled;

	@Scheduled(fixedDelay = 30_000, initialDelay = 5_000)
	public void closeEndedAuctions() {
		if (!enabled) return;
		for (Integer anum : auctMasterDAO.findCloseTargets()) {
			try {
				closeService.closeIfEnded(anum); // 상품마다 따로 트랜잭션 (하나가 실패해도 나머지는 진행)
			} catch (RuntimeException e) {
				logger.error("경매 마감 처리 실패: anum={}", anum, e);
			}
		}
	}
}
