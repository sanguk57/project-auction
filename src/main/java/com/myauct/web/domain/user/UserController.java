package com.myauct.web.domain.user;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.regex.Pattern;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.myauct.web.domain.user.dto.UserDTO;
import com.myauct.web.domain.user.service.UserService;
import com.myauct.web.global.BusinessException;
import com.myauct.web.global.SessionConst;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {

	// register.js 와 같은 규칙. 자바스크립트 검사는 브라우저에서 끄면 그만이라 서버에서도 검사해야 한다.
	private static final Pattern ID_RULE = Pattern.compile("^(?=.*\\d)(?=.*[a-zA-Z])[0-9a-zA-Z]{8,12}$");
	private static final Pattern PW_RULE = Pattern
			.compile("^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$");

	private final UserService userService;

	@GetMapping("/login")
	public void login() {
	}

	@PostMapping("/userCreate")
	public String userCreate(UserDTO dto, String birth, RedirectAttributes ra) {
		try {
			if (dto.getUser_id() == null || !ID_RULE.matcher(dto.getUser_id()).matches()) {
				throw BusinessException.badRequest("아이디 형식이 올바르지 않습니다.");
			}
			if (dto.getPassword() == null || !PW_RULE.matcher(dto.getPassword()).matches()) {
				throw BusinessException.badRequest("비밀번호 형식이 올바르지 않습니다.");
			}
			dto.setAge(calcAge(birth));
			userService.userRegister(dto);
		} catch (BusinessException e) {
			ra.addFlashAttribute("errorMsg", e.getMessage());
			return "redirect:/users/register";
		}
		return "redirect:/users/login";
	}

	/** 생년월일(yyyy-MM-dd) → 나이 (기존 로직과 같이 '현재연도 - 출생연도 + 1') */
	private static int calcAge(String birth) {
		try {
			int birthYear = LocalDate.parse(birth).getYear();
			return LocalDate.now().getYear() - birthYear + 1;
		} catch (DateTimeParseException | NullPointerException e) {
			throw BusinessException.badRequest("생년월일을 입력해주세요.");
		}
	}

	/** 비밀번호 찾기에서 본인확인(/rest/getPw)을 마친 경우에만 변경 화면을 보여준다. */
	@GetMapping("/modifyPassword")
	public String modifyPw(HttpSession session) {
		if (session.getAttribute(SessionConst.PW_RESET_UNUM) == null) {
			return "redirect:/users/passwordFind";
		}
		return "users/modifyPassword";
	}

	@GetMapping("/passwordFind")
	public void passwordFind() {
	}

	@GetMapping("/getIdFind")
	public void getIdFind(String user_id, Model model) {
		model.addAttribute("user_id", user_id);
	}

	@GetMapping("/idFind")
	public void idFind() {
	}

	@GetMapping("/agree")
	public void agree() {
	}

	@GetMapping("/register")
	public void register() {
	}

	@RequestMapping("/jusoPopup")
	public void jusoPopup() {
	}

	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/users/login";
	}
}
