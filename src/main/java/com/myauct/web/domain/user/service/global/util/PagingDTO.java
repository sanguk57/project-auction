package com.myauct.web.domain.user.service.global.util;

import java.util.Arrays;
import java.util.List;

import lombok.Data;

@Data
public class PagingDTO {
	private static final int MAX_CNT_PER_PAGE = 50;

	/** 정렬: ending(마감 임박, 기본) · new(최신 등록) · price_asc · price_desc · bids(입찰 많은 순) */
	public static final List<String> SORTS = Arrays.asList("ending", "new", "price_asc", "price_desc", "bids");
	/** 상태 필터: all · live(진행 중) · ready(시작 전) · ended(마감) */
	public static final List<String> STATUSES = Arrays.asList("all", "live", "ready", "ended");

	// 현재페이지, 시작페이지, 끝페이지, 게시글 총 갯수, 페이지당 글 갯수, 마지막페이지, SQL쿼리에 쓸 start, end
	private int nowPage, startPage, endPage, total, cntPerPage, lastPage, start, end, unum;
	private int cntPage = 10;
	private String value, key;
	private String sort = "ending";
	private String status = "all";
	/** 카테고리 필터 (0 이면 전체) */
	private int cnum;

	public PagingDTO() {
	}

	public PagingDTO(int total, int nowPage, int cntPerPage, String value, String key, int unum) {
		// 주소창에 nowPage=0, cntPerPage=1000000 같은 값을 넣어도 문제없도록 범위 제한
		setCntPerPage(Math.min(Math.max(cntPerPage, 1), MAX_CNT_PER_PAGE));
		setNowPage(Math.max(nowPage, 1));
		setTotal(total);
		setValue(value);
		setKey(key);
		setUnum(unum);
		calcLastPage(getTotal(), getCntPerPage());
		calcStartEndPage(getNowPage(), cntPage);
		calcStartEnd(getNowPage(), getCntPerPage());
	}

	/** 개수를 세기 위한 조건만 담은 객체 (페이지 계산 전) */
	public static PagingDTO filter(String value, String key, int unum, String sort, String status, int cnum) {
		PagingDTO p = new PagingDTO();
		p.setValue(value);
		p.setKey(key);
		p.setUnum(unum);
		p.setSort(sort);
		p.setStatus(status);
		p.setCnum(cnum);
		return p;
	}

	/** 목록 정렬 · 필터 조건을 다른 객체로 옮긴다 */
	public PagingDTO withFiltersOf(PagingDTO other) {
		setSort(other.getSort());
		setStatus(other.getStatus());
		setCnum(other.getCnum());
		return this;
	}

	/** 허용하지 않는 값이면 기본값 (매퍼의 choose 에서 쓰이므로 SQL 에 그대로 들어가지는 않지만, 화면 표시용으로도 정리) */
	public void setSort(String sort) {
		this.sort = SORTS.contains(sort) ? sort : "ending";
	}

	public void setStatus(String status) {
		this.status = STATUSES.contains(status) ? status : "all";
	}

	// 제일 마지막 페이지 계산
	public void calcLastPage(int total, int cntPerPage) {
		setLastPage((int) Math.ceil((double) total / (double) cntPerPage));
	}

	// 시작, 끝 페이지 계산
	public void calcStartEndPage(int nowPage, int cntPage) {
		setEndPage(((int) Math.ceil((double) nowPage / (double) cntPage)) * cntPage);
		if (getLastPage() < getEndPage()) {
			setEndPage(getLastPage());
		}
		setStartPage(getEndPage() - cntPage + 1);
		if (getStartPage() < 1) {
			setStartPage(1);
		}
	}

	// DB 쿼리에서 사용할 start, end값 계산
	public void calcStartEnd(int nowPage, int cntPerPage) {
		setEnd(nowPage * cntPerPage);
		setStart(getEnd() - cntPerPage + 1);
	}

	/** SQL LIMIT 에 쓸 시작 위치 (0부터) */
	public int getOffset() {
		return Math.max(start - 1, 0);
	}
}
