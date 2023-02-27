package com.myauct.web.domain.user.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.myauct.web.domain.user.dto.UserDTO;

public interface UserService {
	List<UserDTO> getUserList();

	UserDTO getUser (String user_id);

	Integer userRegister(UserDTO dto);
	
	Integer userIdChk(String user_id);

	Integer userPwChk (String password);

	Integer userChk(@Param("user_id") String user_id, @Param("password") String password);
	
	String getUserId(@Param("name") String name, @Param("phone") String phone);
	
	Integer getUnum( @Param("user_id") String Id, @Param("phone") String phone);
	
	Integer modifyUserPw( @Param("password")String password, @Param("unum")int unum);
	
	String getName(int unum);
}
