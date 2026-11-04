package com.myauct.web.domain.user.dao;

import org.apache.ibatis.annotations.Param;

import com.myauct.web.domain.user.dto.UserDTO;

public interface UserDAO {

	/** 아이디로 회원 조회 (비밀번호 해시 포함 - 서비스 밖으로 그대로 내보내지 말 것) */
	UserDTO getUser(String user_id);

	Integer userRegister(UserDTO dto);

	Integer userIdChk(String user_id);

	String getUserId(@Param("name") String name, @Param("phone") String phone);

	Integer getUnum(@Param("user_id") String userId, @Param("phone") String phone);

	Integer modifyUserPw(@Param("password") String password, @Param("unum") int unum);

	String getName(int unum);
}
