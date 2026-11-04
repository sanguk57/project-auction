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

	private static boolean isBcryptHash(String value) {
		return value.startsWith("$2a$") || value.startsWith("$2b$") || value.startsWith("$2y$");
	}
}
