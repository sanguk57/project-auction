package com.myauct.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/** 사이트 주소(/web/)로 들어오면 경매 목록으로 보낸다. (예전: 스프링 기본 예제 화면 "Hello world!") */
@Controller
public class HomeController {

	@GetMapping("/")
	public String home() {
		return "redirect:/aucts/index";
	}
}
