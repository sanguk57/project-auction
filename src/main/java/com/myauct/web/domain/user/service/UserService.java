package com.myauct.web.domain.user.service;

import com.myauct.web.domain.user.dto.UserDTO;

public interface UserService {

	/** 아이디/비밀번호가 맞으면 회원정보(비밀번호 제외), 틀리면 null */
	UserDTO login(String user_id, String rawPassword);

	/** 회원가입 (비밀번호는 암호화해서 저장). 이미 있는 아이디면 BusinessException */
	void userRegister(UserDTO dto);

	boolean existsUserId(String user_id);

	String getUserId(String name, String phone);

	Integer getUnum(String userId, String phone);

	boolean modifyUserPw(String rawPassword, int unum);

	String getName(int unum);
}
