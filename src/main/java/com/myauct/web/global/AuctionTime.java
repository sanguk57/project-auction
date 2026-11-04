package com.myauct.web.global;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

/** 경매 시작/종료 시간 처리 (서비스의 입찰 검사와 화면 표시가 같은 규칙을 쓰도록 한 곳에 모음) */
public final class AuctionTime {

	public static final String READY = "READY";
	public static final String LIVE = "LIVE";
	public static final String ENDED = "ENDED";

	private static final DateTimeFormatter IN = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
	private static final DateTimeFormatter OUT = DateTimeFormatter.ofPattern("MM.dd HH:mm");

	private AuctionTime() {
	}

	/** "2023-02-01 12:00" / "2023-02-01 12:00:00" / "2023/02/01 12:00" → 시각, 읽을 수 없으면 null */
	public static LocalDateTime parse(String value) {
		if (value == null) {
			return null;
		}
		String v = value.trim().replace('/', '-').replace('T', ' ');
		if (v.length() < 16) {
			return null;
		}
		try {
			return LocalDateTime.parse(v.substring(0, 16), IN);
		} catch (DateTimeParseException e) {
			return null;
		}
	}

	/** READY(시작 전) / LIVE(진행 중) / ENDED(마감). 기간을 읽을 수 없으면 LIVE */
	public static String status(String start, String end) {
		LocalDateTime s = parse(start);
		LocalDateTime e = parse(end);
		LocalDateTime now = LocalDateTime.now();
		if (s != null && now.isBefore(s)) {
			return READY;
		}
		if (e != null && now.isAfter(e)) {
			return ENDED;
		}
		return LIVE;
	}

	/** 카드에 보여줄 짧은 문구: "3일 남음", "5시간 남음", "11.10 09:00 시작", "마감" */
	public static String label(String start, String end) {
		String status = status(start, end);
		if (READY.equals(status)) {
			return parse(start).format(OUT) + " 시작";
		}
		if (ENDED.equals(status)) {
			return "마감";
		}
		LocalDateTime e = parse(end);
		if (e == null) {
			return "진행 중";
		}
		Duration left = Duration.between(LocalDateTime.now(), e);
		if (left.toDays() >= 1) {
			return left.toDays() + "일 남음";
		}
		if (left.toHours() >= 1) {
			return left.toHours() + "시간 남음";
		}
		return Math.max(left.toMinutes(), 1) + "분 남음";
	}
}
