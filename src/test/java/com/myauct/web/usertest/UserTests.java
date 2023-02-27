package com.myauct.web.usertest;


import javax.inject.Inject;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.myauct.web.domain.user.service.UserService;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class UserTests {
    @Inject
    private UserService userService;

    @Test
    public void userListTest() {
    	userService.getUserList();
    	log.info("getUserList() TEST OK...");
    }
    
//     아이디 찾기 
    @Test
    public void getUserIdTest() {
    	String name = "세종이", phone ="010-0184-5154" ;
    	userService.getUserId(name, phone);
    	log.info("user_id");
    	log.info(userService.getUserId(name, phone));
    }
    @Test
    public void getUnum() {
    	String user_id = "DD", phone ="010-0184-5154" ;
    	userService.getUnum(user_id, phone);
    	log.info(userService.getUnum(user_id, phone));
    }
    
    @Test
    public void userIdChkTest() {
    	userService.userIdChk("CCC");
    	log.info(userService.userIdChk("CCC"));
    }
    
    @Test
    public void userPwChkTest() {
    	userService.userPwChk("1234");
    }
    @Test
    public void userChkTest() {
    	int cnt = userService.userChk("BBB", "1234");
    	log.info("--- UserChk ---");
    	log.info(cnt);
    }
}
