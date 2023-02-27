package com.myauct.web.domain.user;

import java.util.Calendar;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.myauct.web.domain.user.dto.UserDTO;
import com.myauct.web.domain.user.service.UserService;

@Controller
@RequestMapping("/users")
public class UserController {
	@Autowired
	private UserService userService;
	
    @GetMapping("/login")
    public void login(){}

    @PostMapping("/userCreate")
    public String userCreate(UserDTO dto, String birth) {
    	
    	 Calendar now = Calendar.getInstance(); //년월일시분초
    	 Integer currentYear = now.get(Calendar.YEAR);
    		 
    	 //태어난년도를 위한 세팅
         Integer birthYear = Integer.parseInt(birth.substring(0,4));
    	 
         // 현재 년도 - 태어난 년도 => 나이 (만나이X)
         int age = (currentYear - birthYear +1);
       
         
         dto.setAge(age);
        System.out.println(dto.getAddr()); 
    	System.out.println(dto.getEmail());
    	System.out.println(dto.getName());
    	System.out.println(dto.getUser_id());
    	System.out.println(dto.getGender());
    	System.out.println("--- userCreate ---");
    	
    	userService.userRegister(dto);
    
    	return "redirect:/users/login";
    }
    
    @GetMapping("/modifyPassword")
    public void modufyPw(String unum) {
    	
    }
    
    @GetMapping("/passwordFind")
    public void passwordFind() {}
    
    @GetMapping("/getIdFind")
    public void getIdFind(String user_id) {}
    
    @GetMapping("/idFind")
    public void idFind() {}
    
    @GetMapping("/agree")
    public void agree() {}
    
    @GetMapping("/register")
    public void register() {}
 
    @RequestMapping("/jusoPopup")
    public void jusoPopup() {}
    
    @GetMapping("/Sample")
    public void Sample() {}
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
    	session.invalidate();
    	return "redirect:/users/login";
    }
    
}
