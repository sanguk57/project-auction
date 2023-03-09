<%@page import="com.myauct.web.domain.user.dto.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<body>
	<header id="header" class="header d-flex align-items-center fixed-top">
		<div
			class="container-fluid container-xl d-flex align-items-center justify-content-between">
			<a href="index" class="logo d-flex align-items-center"> <!-- Uncomment the line below if you also wish to use an image logo -->
				<!-- <img src="assets/images/logo.png" alt=""> -->
				<h1>Auct-main</h1>
			</a> <i class="mobile-nav-toggle mobile-nav-show bi bi-list"></i> <i
				class="mobile-nav-toggle mobile-nav-hide d-none bi bi-x"></i>
			<nav id="navbar" class="navbar">
				<ul>
					<li><a href="index" class="active">Home</a></li>
					<li><a href="about">About</a></li>
					<li><a href="services">Services</a></li>
					<li><a href="pricing">Pricing</a></li>
					<c:choose>
						<c:when test="${user.name != null}">
							<li class="btn btn-outline-primary dropdown ms-3">
							<span>${user.name}님</span>
								<ul class="dropdown-menu">
									<li><a class="dropdown-item" href="#">내 정보수정</a></li>
									<li><a class="dropdown-item" href="productEnrollment">물품 등록</a></li>
									<li><a class="dropdown-item" href="/web/aucts/index?key=B">관심물품</a></li>
									<li><a class="dropdown-item" href="#">내 문의글</a></li>
									<li><a class="dropdown-item" href="#">답변</a></li>
									<li><a class="dropdown-item" href="/web/users/logout">로그아웃</a></li>
								</ul></li>
						</c:when>
						<c:when test="${user.name == null}">
							<li><a class="get-a-quote " href="/web/users/login">로그인</a></li>
						</c:when>
					</c:choose>
					<li><a class="active" id="nowDate"></a></li>
				</ul>
			</nav>
			<!-- .navbar -->

		</div>
	</header>
	<!-- End Header -->
	<!-- End Header -->


</body>
</html>
