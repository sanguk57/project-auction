package com.myauct.web.domain.user.api;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.myauct.web.domain.user.dto.UserDTO;
import com.myauct.web.domain.user.service.UserServiceImp;

@RestController
@RequestMapping("/rest")
public class UserApi {
  @Autowired
  private UserServiceImp userService;

  @RequestMapping("/userList")
  public List<UserDTO> getUser(){
	  
    return userService.getUserList();
  }

  @RequestMapping(value = "/loginChk", method = RequestMethod.POST)
  @ResponseBody
  public ResponseEntity<String> loginChk(@RequestBody HashMap<String, Object> map){
	  HttpHeaders resHeaders = new HttpHeaders();
	  resHeaders.add("Content-Type", "application/json;charset=UTF-8");
	  
	  System.out.println("--- UserChk---");
	  System.out.println("user_id : "+map.get("user_id")+", password : "+map.get("password"));  
	  
	  int userChk = userService.userChk((String)map.get("user_id"), (String)map.get("password"));
	  if(userService.userIdChk((String)map.get("user_id")) >= 1 ) {
		  
		  if(userChk >= 1) {
			return new ResponseEntity<String>("로그인 성공", resHeaders, HttpStatus.OK);									
			}
			  return new ResponseEntity<String>("비밀번호 확인", resHeaders, HttpStatus.BAD_REQUEST);
	  }
		  return new ResponseEntity<String>("아이디 확인", resHeaders, HttpStatus.BAD_REQUEST);
	}
  
  @PostMapping("/getId")
  @ResponseBody
  public ResponseEntity<String> getUserId(@RequestBody HashMap<String, Object> map){
	  HttpHeaders resHeaders = new HttpHeaders();
	  resHeaders.add("Content-Type", "application/json;charset=UTF-8");
	  System.out.println("--- GetUserId ---");
	  System.out.println("name : "+map.get("name")+", phone : "+map.get("phone"));
	  String id = userService.getUserId((String)map.get("name"), (String)map.get("phone"));
	  System.out.println(id);
	  if(id != null) {
		  return new ResponseEntity<String>(id, resHeaders, HttpStatus.OK);
	  }
	  return new ResponseEntity<String>("가입된 회원이 아닙니다.", resHeaders, HttpStatus.BAD_REQUEST);
  }
  

@RequestMapping(value = "/getPw" , method = RequestMethod.POST)
  @ResponseBody
  public ResponseEntity<String> getUserPw(@RequestBody HashMap<String, Object> map){
	  HttpHeaders resHeaders = new HttpHeaders();
	  resHeaders.add("Content-Type", "application/json;charset=UTF-8");
	  System.out.println("--- GetUserPw ---");
	  System.out.println("user_id : "+map.get("user_id")+", phone : "+map.get("phone"));
	  Integer unum = userService.getUnum((String)map.get("user_id"), (String)map.get("phone"));
	  if(unum == null) {		  
		  return new ResponseEntity<String>("가입된 정보가 없습니다.", resHeaders, HttpStatus.BAD_REQUEST);
	  }
	  else {
		  return new ResponseEntity<String>(""+unum, resHeaders, HttpStatus.OK);
	  }
}
@RequestMapping(value = "/modifyPassword", method = RequestMethod.PUT)
@ResponseBody
public ResponseEntity<String> modifyPassword(@RequestBody HashMap<String, Object> map){
	HttpHeaders resHeaders = new HttpHeaders();
	  resHeaders.add("Content-Type", "application/json;charset=UTF-8");
	  System.out.println("--- modifyPassword ---");
	  System.out.println("unum : "+map.get("unum")+", password : "+map.get("password"));
	  int unum = Integer.parseInt((String.valueOf(map.get("unum"))));
	  System.out.println(unum);
	  int modifyCnk = userService.modifyUserPw((String)map.get("password"), unum);
	  if(modifyCnk > 0 ) {		  
		  return new ResponseEntity<String>("비밀번호 수정 완료", resHeaders, HttpStatus.OK);
	  }
	  else {
		  return new ResponseEntity<String>("에러 발생!!!", resHeaders, HttpStatus.BAD_REQUEST);
	  }
	  
}


@RequestMapping(value = "/userIdChk", method = RequestMethod.POST)
@ResponseBody
public ResponseEntity<Integer> userIdChk(@RequestBody HashMap<String, Object> map) {
	 HttpHeaders resHeaders = new HttpHeaders();
	 resHeaders.add("Content-Type", "application/json;charset=UTF-8");
	 
	 System.out.println("--- UserIdChk ---");
	 System.out.println("user_id : " + map.get("user_id"));
	 
	 int cnt = userService.userIdChk((String)map.get("user_id"));
	 System.out.println(cnt);
	 
		 return new ResponseEntity<Integer>(cnt, resHeaders, HttpStatus.OK);		 	  	  		 
	
	
  }

}
