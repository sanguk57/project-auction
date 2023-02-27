package com.myauct.web.domain.user.dto;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class UserDTO {
	private String user_id, phone, addr, gender, name, password, email;	
	private int unum, age;
}
