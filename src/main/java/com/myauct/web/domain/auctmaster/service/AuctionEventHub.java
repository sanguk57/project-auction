package com.myauct.web.domain.auctmaster.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;

import lombok.Getter;

/**
 * 상품 상세 화면을 보고 있는 사람들에게 입찰 · 즉시구매 · 마감을 바로 알려준다 (Server-Sent Events).
 *  - 브라우저: new EventSource("/web/product-api/stream?anum=1")
 *  - 이벤트는 DB 커밋이 끝난 뒤에 보낸다 (롤백된 입찰이 화면에 보이지 않도록)
 */
@Component
public class AuctionEventHub {

	/** 연결 유지 시간. 끊기면 브라우저(EventSource)가 알아서 다시 연결한다 */
	private static final long TIMEOUT_MS = 30 * 60 * 1000L;

	private final Map<Integer, List<SseEmitter>> listeners = new ConcurrentHashMap<>();

	/** 화면에 보낼 내용 */
	@Getter
	public static class AuctionEvent {
		private final String type; // bid · buy_now · close
		private final int anum, start_amt, join_cnt, min_bid;
		private final String end_chk, bidder, win_name;
		private final Integer win_amt;
		private final boolean bid_possible;

		public AuctionEvent(String type, AuctMasterDTO p, String bidderName) {
			this.type = type;
			this.anum = p.getAnum();
			this.start_amt = p.getStart_amt();
			this.join_cnt = p.getJoin_cnt();
			this.min_bid = p.getMin_bid();
			this.end_chk = p.getEnd_chk();
			this.bidder = AuctMasterDTO.mask(bidderName);
			this.win_name = p.getWin_name_masked();
			this.win_amt = p.getWin_amt();
			this.bid_possible = p.isBidPossible();
		}
	}

	public SseEmitter subscribe(int anum) {
		SseEmitter emitter = new SseEmitter(TIMEOUT_MS);
		List<SseEmitter> list = listeners.computeIfAbsent(anum, k -> new CopyOnWriteArrayList<>());
		list.add(emitter);
		Runnable remove = () -> list.remove(emitter);
		emitter.onCompletion(remove);
		emitter.onTimeout(remove);
		emitter.onError(e -> remove.run());
		try {
			emitter.send(SseEmitter.event().name("hello").data("ok")); // 연결 확인용
		} catch (IOException e) {
			remove.run();
		}
		return emitter;
	}

	/** 지금 진행 중인 트랜잭션이 커밋된 뒤에 보낸다 (트랜잭션 밖이면 바로) */
	public void publishAfterCommit(AuctionEvent event) {
		if (TransactionSynchronizationManager.isSynchronizationActive()) {
			TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
				@Override
				public void afterCommit() {
					publish(event);
				}
			});
		} else {
			publish(event);
		}
	}

	void publish(AuctionEvent event) {
		List<SseEmitter> list = listeners.get(event.getAnum());
		if (list == null) return;
		for (SseEmitter emitter : list) {
			try {
				emitter.send(SseEmitter.event().name(event.getType()).data(event));
			} catch (IOException | IllegalStateException e) {
				list.remove(emitter); // 창을 닫은 사람
			}
		}
	}

	/** 프록시 · 공유기가 오래 조용한 연결을 끊지 않도록 25초마다 신호를 보낸다 */
	@Scheduled(fixedRate = 25_000)
	public void heartbeat() {
		listeners.forEach((anum, list) -> {
			for (SseEmitter emitter : list) {
				try {
					emitter.send(SseEmitter.event().comment("ping"));
				} catch (IOException | IllegalStateException e) {
					list.remove(emitter);
				}
			}
		});
		listeners.values().removeIf(List::isEmpty);
	}

	/** 테스트 · 모니터링용: 지금 연결된 수 */
	public int listenerCount(int anum) {
		List<SseEmitter> list = listeners.get(anum);
		return list == null ? 0 : list.size();
	}
}
