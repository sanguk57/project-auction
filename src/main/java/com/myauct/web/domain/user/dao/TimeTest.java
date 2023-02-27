package com.myauct.web.domain.user.dao;

import org.apache.ibatis.annotations.Select;

public interface TimeTest {
	@Select("select now()")
	String getTime();
	
	String getUser();
	
}
