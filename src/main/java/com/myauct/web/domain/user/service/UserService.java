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

	/** 연락처 (이름 · 휴대폰 · 이메일, 비밀번호 제외). 탈퇴 회원이면 null */
	UserDTO getContact(int unum);

	/** 내 정보 수정 (이름 · 휴대폰 · 이메일 · 주소 · 성별). 수정된 정보(비밀번호 제외)를 돌려준다 */
	UserDTO updateProfile(int unum, UserDTO form);

	/** 현재 비밀번호를 확인한 뒤 변경 */
	void changePassword(int unum, String currentPassword, String newPassword);

	/** 비밀번호가 맞는지 */
	boolean checkPassword(int unum, String rawPassword);
}
