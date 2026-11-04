package com.myauct.web.domain.user.dao;

import org.apache.ibatis.annotations.Param;

import com.myauct.web.domain.user.dto.UserDTO;

public interface UserDAO {

	/** 아이디로 회원 조회 (탈퇴 회원 제외, 비밀번호 해시 포함 - 서비스 밖으로 그대로 내보내지 말 것) */
	UserDTO getUser(String user_id);

	/** 회원번호로 조회 (탈퇴 회원 제외, 비밀번호 해시 포함) */
	UserDTO getUserByUnum(int unum);

	Integer userRegister(UserDTO dto);

	/** 탈퇴 회원 포함 (탈퇴하면 아이디를 바꾸므로 원래 아이디는 다시 쓸 수 있다) */
	Integer userIdChk(String user_id);

	String getUserId(@Param("name") String name, @Param("phone") String phone);

	Integer getUnum(@Param("user_id") String userId, @Param("phone") String phone);

	Integer modifyUserPw(@Param("password") String password, @Param("unum") int unum);

	String getName(int unum);

	/** 이름 · 휴대폰 · 이메일 · 주소 · 성별 수정 */
	Integer updateProfile(UserDTO dto);

	/** 탈퇴: 개인정보를 지우고 del_yn = Y (입찰 · 낙찰 기록은 남아야 하므로 행은 지우지 않음) */
	Integer withdraw(int unum);
}
