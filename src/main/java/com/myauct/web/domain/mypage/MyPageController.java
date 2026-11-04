package com.myauct.web.domain.mypage;

import java.util.Arrays;
import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.myauct.web.domain.mypage.service.MyPageService;
import com.myauct.web.domain.user.dto.UserDTO;
import com.myauct.web.domain.user.service.UserService;
import com.myauct.web.global.BusinessException;
import com.myauct.web.global.SessionConst;

import lombok.RequiredArgsConstructor;

/**
 * 마이페이지 (/my). servlet-context.xml 의 LoginCheckInterceptor 가 로그인을 먼저 확인한다.
 *  tab = bids 입찰 내역 / wins 낙찰 받은 상품 / sales 판매 현황 / profile 내 정보
 */
@Controller
@RequestMapping("/my")
@RequiredArgsConstructor
public class MyPageController {

	private static final List<String> TABS = Arrays.asList("bids", "wins", "sales", "profile");

	private final MyPageService myPageService;
	private final UserService userService;

	@GetMapping
	public String myPage(@RequestParam(defaultValue = "bids") String tab, Model model,
			@SessionAttribute(SessionConst.LOGIN_USER) UserDTO user) {
		if (!TABS.contains(tab)) tab = "bids";
		int unum = user.getUnum();
		model.addAttribute("tab", tab);
		// 탭 이름 옆 숫자를 위해 목록은 항상 같이 조회 (각각 가벼운 쿼리)
		model.addAttribute("bids", myPageService.myBids(unum));
		model.addAttribute("wins", myPageService.myWins(unum));
		model.addAttribute("sales", myPageService.mySales(unum));
		if ("profile".equals(tab)) {
			model.addAttribute("me", userService.getContact(unum));
		}
		return "my/mypage";
	}

	@PostMapping("/profile")
	public String updateProfile(UserDTO form, HttpSession session, RedirectAttributes ra,
			@SessionAttribute(SessionConst.LOGIN_USER) UserDTO user) {
		try {
			UserDTO updated = userService.updateProfile(user.getUnum(), form);
			session.setAttribute(SessionConst.LOGIN_USER, updated); // 상단 메뉴의 이름도 바로 바뀌도록
			ra.addFlashAttribute("okMsg", "내 정보를 저장했습니다.");
		} catch (BusinessException e) {
			ra.addFlashAttribute("errorMsg", e.getMessage());
		}
		return "redirect:/my?tab=profile";
	}

	@PostMapping("/password")
	public String changePassword(@RequestParam String currentPassword, @RequestParam String newPassword,
			RedirectAttributes ra, @SessionAttribute(SessionConst.LOGIN_USER) UserDTO user) {
		try {
			userService.changePassword(user.getUnum(), currentPassword, newPassword);
			ra.addFlashAttribute("okMsg", "비밀번호를 변경했습니다.");
		} catch (BusinessException e) {
			ra.addFlashAttribute("errorMsg", e.getMessage());
		}
		return "redirect:/my?tab=profile";
	}

	@PostMapping("/withdraw")
	public String withdraw(@RequestParam String password, HttpSession session, RedirectAttributes ra,
			@SessionAttribute(SessionConst.LOGIN_USER) UserDTO user) {
		try {
			myPageService.withdraw(user.getUnum(), password);
		} catch (BusinessException e) {
			ra.addFlashAttribute("errorMsg", e.getMessage());
			return "redirect:/my?tab=profile";
		}
		session.invalidate();
		return "redirect:/aucts/index?withdrawn=1";
	}
}
