<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<%-- CSRF 토큰: csrf.js 가 요청 · 폼에 자동으로 붙인다 --%>
<meta name="csrf-token" content="${_csrf}">
<script src="/web/js/csrf.js?v=<%=System.currentTimeMillis() %>"></script>

<title>MyAuct - 중고 경매</title>
<meta content="중고 물품 경매 사이트" name="description">
<meta content="" name="keywords">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<!-- Favicons -->
<link href="/web/images/favicon.png" rel="icon">
<link href="/web/images/apple-touch-icon.png" rel="apple-touch-icon">

<!-- 글꼴: Pretendard (한글 UI 용 무료 글꼴, SIL OFL) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css">

<!-- Vendor CSS Files -->
<link href="/web/vendor/bootstrap/css/bootstrap.min.css"
	rel="stylesheet">
<link href="/web/vendor/bootstrap-icons/bootstrap-icons.css"
	rel="stylesheet">
<link href="/web/vendor/fontawesome-free/css/all.min.css"
	rel="stylesheet">
<link href="/web/vendor/glightbox/css/glightbox.min.css"
	rel="stylesheet">
<link href="/web/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">
<link href="/web/vendor/aos/aos.css" rel="stylesheet">

<!-- Template Main CSS File -->
<link href="/web/css/main.css?v=<%=System.currentTimeMillis() %>" rel="stylesheet">
<link href="/web/css/myauct.css?v=<%=System.currentTimeMillis() %>" rel="stylesheet">

<link href="/web/css/jquery.datetimepicker.min.css?v=<%=System.currentTimeMillis() %>" rel="stylesheet">
<!-- =======================================================
  * Template Name: Logis - v1.3.0
  * Template URL: https://bootstrapmade.com/logis-bootstrap-logistics-website-template/
  * Author: BootstrapMade.com
  * License: https://bootstrapmade.com/license/
  ======================================================== -->
</head>

</html>
