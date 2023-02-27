package com.myauct.web.domain.user.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.myauct.web.domain.user.dao.UserDAO;
import com.myauct.web.domain.user.dto.UserDTO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class UserServiceImp implements UserService{
    
    private final UserDAO userDAO;
   
	@Override
	public List<UserDTO> getUserList() {
		return userDAO.getUserList();
	}

	@Override
	public Integer userRegister(UserDTO dto) {
		return userDAO.userRegister(dto);
	}

	@Override
	public Integer userIdChk(String user_id) {
		return userDAO.userIdChk(user_id);
	}

	@Override
	public Integer userPwChk(String password) {
		return userDAO.userPwChk(password);
	}

	@Override
	public Integer userChk(String user_id, String password) {
		return userDAO.userChk(user_id, password);
	}

	@Override
	public String getUserId(String name, String phone) {
		return userDAO.getUserId(name, phone);
	}

	@Override
	public Integer getUnum(String Id, String phone) {
		return userDAO.getUnum(Id, phone);
	}

	@Override
	public Integer modifyUserPw(String password, int unum) {
		return userDAO.modifyUserPw(password, unum);
	}
    
	@Override
    public UserDTO getUser(String user_id) {   
		return userDAO.getUser(user_id);
	}

	@Override
	public String getName(int unum) {
		return userDAO.getName(unum);
	}
	
}
