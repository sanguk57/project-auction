<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="jakarta.tags.core" prefix="c"%>
	<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<title>로그인 - MyAuct</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous">
<%@ include file="/WEB-INF/views/include/authHead.jsp"%>
</head>

<body class="ma-auth">
	<div class="ma-auth-wrap">
		<a class="ma-auth-logo" href="/web/aucts/index"><i class="bi bi-hammer"></i>MyAuct</a>
		<p class="ma-auth-sub">로그인하고 경매에 참여하세요</p>
		<main class="ma-auth-card">
			<form>
				<c:if test="${joined}">
					<div class="alert alert-success d-flex gap-2 align-items-center py-2" role="alert">
						<i class="bi bi-check-circle-fill"></i> 회원가입이 완료되었습니다. 로그인해주세요.
					</div>
				</c:if>
				<div class="form-floating mb-3">
					<input type="text" class="form-control id" id="floatingInput" placeholder="아이디" autocomplete="username">
					<label for="floatingInput">아이디</label>
				</div>
				<div class="form-floating mb-2">
					<input type="password" class="form-control pw" id="floatingPassword" placeholder="비밀번호" autocomplete="current-password">
					<label for="floatingPassword">비밀번호</label>
				</div>
				<div class="form-check my-3">
					<input class="form-check-input id_ck" type="checkbox" value="" id="flexCheckChecked">
					<label class="form-check-label small" for="flexCheckChecked">아이디 기억하기</label>
				</div>
				<button class="w-100 btn btn-lg btn-primary btn_sm" type="submit">로그인</button>
				<div class="ma-auth-links mb-0">
					<span><a href="javascript:popupId()">아이디 찾기</a> · <a href="javascript:popupPw()">비밀번호 찾기</a></span>
					<a href="${path}/users/agree" class="fw-semibold" style="color: var(--ma-primary)">회원가입</a>
				</div>
			</form>
		</main>
		<p class="text-center small text-muted mt-4"><a href="/web/aucts/index" class="text-muted">← 경매 둘러보기</a></p>
	</div>
	<script src="https://code.jquery.com/jquery-3.6.1.js"
		integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
		integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.min.js"
		integrity="sha384-IDwe1+LCz02ROU9k972gdyvl+AESN10+x7tBKgc9I5HFtuNz0wWnPclzo6p9vxnk"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
		crossorigin="anonymous"></script>

	<script src="${path}/js/login.js?v=<%=System.currentTimeMillis() %>" defer></script>
	
</body>

</html>