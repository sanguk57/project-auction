<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 로그인 · 회원가입 등 계정 화면 공통 (각 화면의 <head> 안, Bootstrap CSS 다음에 include) --%>
<link href="/web/images/favicon.png" rel="icon">
<%-- CSRF 토큰: csrf.js 가 요청 · 폼에 자동으로 붙인다 --%>
<meta name="csrf-token" content="${_csrf}">
<script src="/web/js/csrf.js?v=<%=System.currentTimeMillis() %>"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css">
<link href="/web/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
<link href="/web/css/myauct.css?v=<%=System.currentTimeMillis() %>" rel="stylesheet">
