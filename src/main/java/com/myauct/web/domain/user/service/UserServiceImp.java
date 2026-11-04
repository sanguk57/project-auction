package com.myauct.web.domain.user.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.myauct.web.domain.user.dao.UserDAO;
import com.myauct.web.domain.user.dto.UserDTO;
import com.myauct.web.global.BusinessException;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class UserServiceImp implements UserService {

	private static final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	/** 회원가입(UserController) · register.js 와 같은 규칙 */
	static final java.util.regex.Pattern PHONE_RULE = java.util.regex.Pattern.compile("^01[016789]-\\d{3,4}-\\d{4}$");
	static final java.util.regex.Pattern PW_RULE = java.util.regex.Pattern
			.compile("^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$");

	private final UserDAO userDAO;

	@Override
	public UserDTO login(String user_id, String rawPassword) {
		if (user_id == null || rawPassword == null) {
			return null;
		}
		UserDTO user = userDAO.getUser(user_id);
		if (user == null || user.getPassword() == null) {
			return null;
		}

		String stored = user.getPassword();
		boolean matched;
		if (isBcryptHash(stored)) {
			matched = passwordEncoder.matches(rawPassword, stored);
		} else {
			// 암호화 적용 전에 가입한 회원(평문 저장) → 로그인 성공 시 암호화해서 다시 저장
			matched = stored.equals(rawPassword);
			if (matched) {
				userDAO.modifyUserPw(passwordEncoder.encode(rawPassword), user.getUnum());
			}
		}
		if (!matched) {
			return null;
		}
		user.setPassword(null); // 세션에 비밀번호를 들고 다니지 않음
		return user;
	}

	@Override
	public void userRegister(UserDTO dto) {
		if (existsUserId(dto.getUser_id())) {
			throw BusinessException.badRequest("이미 사용 중인 아이디입니다.");
		}
		dto.setPassword(passwordEncoder.encode(dto.getPassword()));
		userDAO.userRegister(dto);
	}

	@Override
	public boolean existsUserId(String user_id) {
		Integer cnt = userDAO.userIdChk(user_id);
		return cnt != null && cnt > 0;
	}

	@Override
	public String getUserId(String name, String phone) {
		return userDAO.getUserId(name, phone);
	}

	@Override
	public Integer getUnum(String userId, String phone) {
		return userDAO.getUnum(userId, phone);
	}

	@Override
	public boolean modifyUserPw(String rawPassword, int unum) {
		Integer cnt = userDAO.modifyUserPw(passwordEncoder.encode(rawPassword), unum);
		return cnt != null && cnt > 0;
	}

	@Override
	public String getName(int unum) {
		return userDAO.getName(unum);
	}

	@Override
	public UserDTO getContact(int unum) {
		UserDTO u = userDAO.getUserByUnum(unum);
		if (u != null) {
			u.setPassword(null);
		}
		return u;
	}

	@Override
	public UserDTO updateProfile(int unum, UserDTO form) {
		String name = form.getName() == null ? "" : form.getName().trim();
		if (name.isEmpty()) {
			throw BusinessException.badRequest("이름을 입력해주세요.");
		}
		if (form.getPhone() == null || !PHONE_RULE.matcher(form.getPhone()).matches()) {
			throw BusinessException.badRequest("휴대폰 번호를 확인해주세요. (예: 010-1234-5678)");
		}
		form.setUnum(unum);
		form.setName(name);
		form.setEmail(blankToNull(form.getEmail()));
		form.setAddr(blankToNull(form.getAddr()));
		form.setGender(blankToNull(form.getGender()));
		userDAO.updateProfile(form);
		return getContact(unum);
	}

	@Override
	public void changePassword(int unum, String currentPassword, String newPassword) {
		if (!checkPassword(unum, currentPassword)) {
			throw BusinessException.badRequest("현재 비밀번호가 맞지 않습니다.");
		}
		if (newPassword == null || !PW_RULE.matcher(newPassword).matches()) {
			throw BusinessException.badRequest("새 비밀번호는 영문 · 숫자 · 특수문자를 포함해 8자 이상이어야 합니다.");
		}
		modifyUserPw(newPassword, unum);
	}

	@Override
	public boolean checkPassword(int unum, String rawPassword) {
		UserDTO u = userDAO.getUserByUnum(unum);
		return u != null && rawPassword != null && login(u.getUser_id(), rawPassword) != null;
	}

	private static String blankToNull(String s) {
		return s == null || s.trim().isEmpty() ? null : s.trim();
	}

	private static boolean isBcryptHash(String value) {
		return value.startsWith("$2a$") || value.startsWith("$2b$") || value.startsWith("$2y$");
	}
}
