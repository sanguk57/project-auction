package com.myauct.web.domain.auctmaster.api;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import com.myauct.web.domain.auctboard.dto.AuctBoardMemoDTO;
import com.myauct.web.domain.auctboard.service.AuctBoardService;
import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;
import com.myauct.web.domain.auctcategory.service.AuctCategoryService;
import com.myauct.web.domain.auctconcern.service.AuctConcernService;
import com.myauct.web.domain.auctmaster.dto.SuggestDTO;
import com.myauct.web.domain.auctmaster.service.AuctionEventHub;
import com.myauct.web.domain.auctmaster.service.AuctMasterService;
import com.myauct.web.domain.user.dto.UserDTO;
import com.myauct.web.global.BusinessException;
import com.myauct.web.global.SessionConst;

import lombok.RequiredArgsConstructor;

/**
 * 고친 점: 예전에는 "누가" 요청했는지(unum)를 요청 body 에서 받았다.
 * → 개발자도구로 unum 만 바꾸면 남의 이름으로 입찰/댓글/찜이 가능했음.
 * 지금은 로그인 세션의 회원번호만 사용한다.
 */
@RequestMapping("/product-api")
@RestController
@RequiredArgsConstructor
public class RestAPIController {

	private final AuctMasterService auctMasterService;
	private final AuctCategoryService auctCategoryService;
	private final AuctConcernService auctConcernService;
	private final AuctBoardService auctBoardService;
	private final AuctionEventHub eventHub;

	/** 목록 화면의 상품 썸네일 { "상품번호": ["경로", ...] } */
	@PostMapping("/uploadAjaxAction")
	public Map<String, List<String>> uploadAjaxAction(@RequestBody Map<String, List<Integer>> map) {
		return auctMasterService.getThumbnailPaths(map.get("anum"));
	}

	/** 검색창 자동완성 GET /product-api/suggest?q=검색어 → [{keyword, type, cnt}, ...] */
	@GetMapping("/suggest")
	public List<SuggestDTO> suggest(@RequestParam(name = "q", required = false) String q) {
		return auctMasterService.suggest(q);
	}

	/** 입찰 { anum, start_amt(입찰가), amount(수량) } */
	@PutMapping("/product_auction")
	public ResponseEntity<String> productAmt(@RequestBody Map<String, Object> map,
			@SessionAttribute(name = SessionConst.LOGIN_USER, required = false) UserDTO user) {
		int unum = requireLogin(user);
		auctMasterService.bid(toInt(map, "anum"), unum, toInt(map, "start_amt"), toInt(map, "amount"));
		return ResponseEntity.ok("입찰 완료");
	}

	/** 즉시구매 { anum, amount(수량) } */
	@PostMapping("/buy_now")
	public ResponseEntity<String> buyNow(@RequestBody Map<String, Object> map,
			@SessionAttribute(name = SessionConst.LOGIN_USER, required = false) UserDTO user) {
		int unum = requireLogin(user);
		Object amount = map.get("amount");
		auctMasterService.buyNow(toInt(map, "anum"), unum, amount == null ? 1 : toInt(map, "amount"));
		return ResponseEntity.ok("즉시구매 완료");
	}

	/** 상세 화면 실시간 갱신 (Server-Sent Events): 입찰 · 즉시구매 · 마감이 생기면 바로 알려준다 */
	@GetMapping(path = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
	public SseEmitter stream(@RequestParam int anum) {
		return eventHub.subscribe(anum);
	}

	@PostMapping("/product_category")
	public Map<Integer, String> productCate() {
		Map<Integer, String> categoryMap = new HashMap<>();
		for (AuctCategoryDTO dto : auctCategoryService.getCategoryList()) {
			categoryMap.put(dto.getCnum(), dto.getCategory());
		}
		return categoryMap;
	}

	@PostMapping("/product_concern")
	public ResponseEntity<String> productConcern(@RequestBody Map<String, Object> map,
			@SessionAttribute(name = SessionConst.LOGIN_USER, required = false) UserDTO user) {
		auctConcernService.addConcern(toInt(map, "anum"), requireLogin(user));
		return ResponseEntity.ok("OK");
	}

	@DeleteMapping("/product_unconcern")
	public ResponseEntity<String> productUnconcern(@RequestBody Map<String, Object> map,
			@SessionAttribute(name = SessionConst.LOGIN_USER, required = false) UserDTO user) {
		auctConcernService.removeConcern(toInt(map, "anum"), requireLogin(user));
		return ResponseEntity.ok("OK");
	}

	/** 내가 찜한 상품 번호 목록 */
	@PostMapping("/concern_list")
	public List<Integer> concernList(
			@SessionAttribute(name = SessionConst.LOGIN_USER, required = false) UserDTO user) {
		return auctConcernService.concernAnumList(requireLogin(user));
	}

	@PostMapping("/create_board")
	public ResponseEntity<String> createBoard(@RequestBody Map<String, Object> map,
			@SessionAttribute(name = SessionConst.LOGIN_USER, required = false) UserDTO user) {
		auctBoardService.createBoard(toInt(map, "anum"), requireLogin(user), (String) map.get("subject"),
				(String) map.get("contents"));
		return ResponseEntity.ok("댓글쓰기 success");
	}

	@PostMapping("/create_memo")
	public ResponseEntity<String> createMemo(@RequestBody Map<String, Object> map,
			@SessionAttribute(name = SessionConst.LOGIN_USER, required = false) UserDTO user) {
		auctBoardService.createMemo(toInt(map, "qnum"), requireLogin(user), (String) map.get("memo"));
		return ResponseEntity.ok("답글쓰기 success");
	}

	@PostMapping("/memoList")
	public List<AuctBoardMemoDTO> memoList(@RequestBody Map<String, Object> map) {
		return auctBoardService.getMemoList(toInt(map, "qnum"));
	}

	// ---------------------------------------------------------------------

	private static int requireLogin(UserDTO user) {
		if (user == null) {
			throw BusinessException.unauthorized();
		}
		return user.getUnum();
	}

	/** JSON 의 숫자/문자열("1,000" 포함)을 int 로 변환 */
	private static int toInt(Map<String, Object> map, String key) {
		Object v = map.get(key);
		if (v instanceof Number) {
			return ((Number) v).intValue();
		}
		if (v instanceof String) {
			try {
				return Integer.parseInt(((String) v).replace(",", "").trim());
			} catch (NumberFormatException e) {
				// 아래에서 처리
			}
		}
		throw BusinessException.badRequest(key + " 값이 올바르지 않습니다.");
	}
}
