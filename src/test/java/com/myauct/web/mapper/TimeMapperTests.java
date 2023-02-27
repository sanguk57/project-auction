package com.myauct.web.mapper;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.myauct.web.domain.user.dao.TimeTest;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class TimeMapperTests {
	@Autowired
	private TimeTest timeTest;
	
	
	@Test
	public void getTime() {
		log.info("-------getTime()호출------");
		timeTest.getTime();
	}
	
	@Test
	public void getUserTest() {
		 Calendar now = Calendar.getInstance(); //년월일시분초
    	 Integer currentYear = now.get(Calendar.YEAR);
    		 
         log.info(currentYear);
//    	 //태어난년도를 위한 세팅
         Integer birthYear = Integer.parseInt("2013-02-10".substring(0,4));
    	 
    	 log.info(birthYear);
//    	 //태어난 년도

//
//    	 // 현재 년도 - 태어난 년도 => 나이 (만나이X)
         int age = (currentYear - birthYear +1);
         String Age = Integer.toString(age);
         
         log.info("------------------------------"+Age);
		timeTest.getTime();	
	}
	
}
