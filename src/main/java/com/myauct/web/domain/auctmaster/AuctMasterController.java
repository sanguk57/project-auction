package com.myauct.web.domain.auctmaster;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.myauct.web.domain.auctboard.service.AuctBoardService;
import com.myauct.web.domain.auctcategory.dto.AuctCategoryDTO;
import com.myauct.web.domain.auctcategory.service.AuctCategoryService;
import com.myauct.web.domain.auctconcern.service.AuctConcernService;
import com.myauct.web.domain.auctmaster.dto.AuctMasterDTO;
import com.myauct.web.domain.auctmaster.service.AuctMasterService;
import com.myauct.web.domain.user.dto.UserDTO;
import com.myauct.web.domain.user.service.global.util.PagingDTO;
import com.myauct.web.global.BusinessException;
import com.myauct.web.global.SessionConst;

import lombok.RequiredArgsConstructor;

/*
 * 삭제: /aucts/loginUser (아이디만으로 로그인되던 주소 → 로그인은 /rest/loginChk 에서 처리)
 *
 * 상품 등록/수정/삭제 주소는 servlet-context.xml 의 LoginCheckInterceptor 가
 * 로그인 여부를 먼저 확인하므로, 여기서 user 는 null 이 아니다.
 */
@Controller
@RequestMapping("/aucts")
@RequiredArgsConstructor
public class AuctMasterController {

	private final AuctCategoryService auctCategoryService;
	private final AuctMasterService auctMasterService;
	private final AuctConcernService auctConcernService;
	private final AuctBoardService auctBoardService;

	@Value("${juso.confmKey:}")
	private String jusoKey;

	@RequestMapping("/index")
	public void index(@SessionAttribute(name = SessionConst.LOGIN_USER, required = false) UserDTO user,
			Model model, @RequestParam(defaultValue = "") String value,
			@RequestParam(required = false) String key, @RequestParam(defaultValue = "1") int nowPage,
			@RequestParam(defaultValue = "8") int cntPerPage) {
		loadProductList(user, model, value, key, nowPage, cntPerPage);
	}

	@GetMapping("/about")
	public void about(@SessionAttribute(name = SessionConst.LOGIN_USER, required = false) UserDTO user,
			Model model, @RequestParam(defaultValue = "") String value,
			@RequestParam(required = false) String key, @RequestParam(defaultValue = "1") int nowPage,
			@RequestParam(defaultValue = "12") int cntPerPage) {
		loadProductList(user, model, value, key, nowPage, cntPerPage);
	}

	/** index 와 about 에 똑같은 코드가 60줄씩 복사돼 있던 것을 하나로 합침 */
	private void loadProductList(UserDTO user, Model model, String value, String key, int nowPage,
			int cntPerPage) {
		Map<String, Integer> cntMap = new HashMap<>();
		int total = auctMasterService.getProductCnt(value);
		cntMap.put("productCnt", total);

		int unum = 0;
		int pagingTotal = total;
		if (user != null) {
			unum = user.getUnum();
			int userProductCnt = auctMasterService.getUserProductCnt(unum);
			int concernCnt = auctConcernService.concernCnt(unum);
			cntMap.put("userProductCnt", userProductCnt);
			cntMap.put("concernCnt", concernCnt);
			cntMap.put("userBoardCnt", auctBoardService.userBoardCnt(unum));

			if ("A".equals(key)) {
				pagingTotal = userProductCnt;
			} else if ("B".equals(key)) {
				pagingTotal = concernCnt;
			}
		} else if ("A".equals(key) || "B".equals(key)) {
			key = null; // 로그인 안 했으면 '내 상품/찜 목록' 대신 전체 목록
		}

		PagingDTO paging = new PagingDTO(pagingTotal, nowPage, cntPerPage, value, key, unum);
		model.addAttribute("paging", paging);
		model.addAttribute("cntMap", cntMap);
		model.addAttribute("productList", auctMasterService.getProductList(paging));
	}

	// contact / pricing / services / sample-inner-page 는 물류 회사 템플릿 페이지라 삭제함

	@GetMapping("/productEnrollment")
	public void productEnrollment(Model model) {
		// 예전: 화면이 뜬 뒤 Ajax 로 카테고리를 따로 불러왔음 → 처음부터 함께 그린다
		model.addAttribute("categoryList", auctCategoryService.getCategoryList());
	}

	/** 도로명주소 검색 팝업. 승인키는 app.properties 의 juso.confmKey (예전: JSP 에 키가 직접 적혀 있었음) */
	@RequestMapping("/jusoPopup")
	public String jusoPopup(Model model) {
		model.addAttribute("jusoKey", jusoKey);
		return "aucts/jusoPopup";
	}

	/** 상품 등록 */
	@PostMapping("/auctionItem")
	public String auctionItem(AuctMasterDTO auctMasterDTO, AuctCategoryDTO categoryDTO,
			@RequestParam(required = false) MultipartFile[] uploadFile,
			@SessionAttribute(SessionConst.LOGIN_USER) UserDTO user, RedirectAttributes ra) {
		try {
			int anum = auctMasterService.registerProduct(auctMasterDTO, categoryDTO, uploadFile, user.getUnum());
			return "redirect:/aucts/productView?anum=" + anum;
		} catch (BusinessException e) {
			ra.addFlashAttribute("errorMsg", e.getMessage());
			return "redirect:/aucts/productEnrollment";
		}
	}

	/** 상품 수정 화면 (본인 상품만) */
	@GetMapping("/modifyProduct")
	public String modifyProduct(int anum, Model model, @SessionAttribute(SessionConst.LOGIN_USER) UserDTO user,
			RedirectAttributes ra) {
		AuctMasterDTO dto = auctMasterService.getProduct(anum);
		if (dto.getUnum() != user.getUnum()) {
			ra.addFlashAttribute("errorMsg", "본인이 등록한 상품만 수정할 수 있습니다.");
			return "redirect:/aucts/productView?anum=" + anum;
		}
		model.addAttribute("category", auctCategoryService.getCategory(dto.getCnum()));
		model.addAttribute("categoryList", auctCategoryService.getCategoryList());
		model.addAttribute("uploadFileList", auctMasterService.getImagePaths(anum));
		model.addAttribute("aDTO", dto);
		return "aucts/modifyProduct";
	}

	/** 상품 수정 저장 (예전: 수정 화면이 등록 주소로 전송돼서 수정 대신 새 상품이 생겼음) */
	@PostMapping("/productModify")
	public String productModify(AuctMasterDTO auctMasterDTO, AuctCategoryDTO categoryDTO,
			@RequestParam(required = false) MultipartFile[] uploadFile,
			@SessionAttribute(SessionConst.LOGIN_USER) UserDTO user, RedirectAttributes ra) {
		try {
			auctMasterService.modifyProduct(auctMasterDTO, categoryDTO, uploadFile, user.getUnum());
		} catch (BusinessException e) {
			ra.addFlashAttribute("errorMsg", e.getMessage());
		}
		// 예전: anum 없이 productView 로 이동해서 400 에러
		return "redirect:/aucts/productView?anum=" + auctMasterDTO.getAnum();
	}

	/** 상품 삭제 (예전: 링크(GET)로 삭제 + 본인 확인 없음 → 주소만 알면 누구나 남의 상품 삭제 가능) */
	@PostMapping("/deleteProduct")
	public String deleteProduct(int anum, @SessionAttribute(SessionConst.LOGIN_USER) UserDTO user,
			RedirectAttributes ra) {
		try {
			auctMasterService.deleteProduct(anum, user.getUnum());
		} catch (BusinessException e) {
			ra.addFlashAttribute("errorMsg", e.getMessage());
			return "redirect:/aucts/productView?anum=" + anum;
		}
		return "redirect:/aucts/index";
	}

	/** 상품 상세 */
	@GetMapping("/productView")
	public String productView(int anum, Model model) {
		AuctMasterDTO auctMasterDTO = auctMasterService.getProduct(anum);
		model.addAttribute("auctMasterDTO", auctMasterDTO);
		model.addAttribute("category", auctCategoryService.getCategory(auctMasterDTO.getCnum()));
		model.addAttribute("uploadFileList", auctMasterService.getImagePaths(anum));
		model.addAttribute("boardList", auctBoardService.boardList(anum));
		return "aucts/service-details";
	}
}
