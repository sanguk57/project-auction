<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author"
	content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
<meta name="generator" content="Hugo 0.104.2">
<title>Login Page</title>

<link rel="canonical"
	href="https://getbootstrap.com/docs/5.2/examples/sign-in/">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous">
<style>
img {
	width: 40px;
	height: 40px;
	border: 1px solid black;
}

ul, ol {
	margin: 0;
	padding: 0;
	list-style: none;
	margin-left: 5px;
	margin-right: 5px;
}

a {
	text-decoration: none;
}

.test {
	border: 0px solid black;
	margin-top: 200px;
}
</style>
</head>

<body class="text-center">
	<div class="container test">
		<main class="form-signin w-25 m-auto ">
			<form>
				<h1 class="h3 mb-3 fw-normal title">Auct_Login</h1>
				<div class="form-floating mt-3">
					<input type="text" class="form-control mt-3 id" id="floatingInput"
						placeholder="Id"> <label for="floatingInput">Id</label>
				</div>
				<div class="form-floating mt-3">
					<input type="password" class="form-control pw"
						id="floatingPassword" placeholder="Password"> <label
						for="floatingPassword">Password</label>
				</div>
				<div class="d-flex justify-content-end">
					<div class="form-check mx-3">
						<input class="form-check-input id_ck" type="checkbox" value=""
							id="flexCheckChecked"> <label class="form-check-label"
							for="flexCheckChecked"> 아이디 기억하기 </label>
					</div>
				</div>
				<div class="d-flex justify-content-between">
					<div class="fw-lighter">

						<a href="javascript:popupId()" class="link_look"
							data-clk="log_off.searchid">아이디 찾기</a>&nbsp; <a
							href="javascript:popupPw()" class="link_look"
							data-clk="log_off.searchpass">비밀번호 찾기</a>
					</div>
					<div>
						<a href="${path}/users/agree">회원가입</a>
					</div>
				</div>

				<div class="row">
					<div class="col-12">
						<button
							class="w-100 h-100 btn btn-lg btn-primary mt-1 btn_sm m-0 p-0"
							type="submit">로그인</button>
					</div>

				</div>
				<ul class="d-flex justify-content-evenly mt-3">
					<li><a href="#" class="api-btn"><img
							src="${path}/images/kakao-talk.png"></a></li>
					<li><a href="#"><img src="${path}/images/naver.png" alt=""></a></li>
					<li><a href="#"><img src="${path}/images/google.png" alt=""></a></li>
					<li><a href="#"><img src="${path}/images/facebook.png" alt=""></a></li>
					<li><a href="#"><img src="${path}/images/twitter.png" alt=""></a></li>
				</ul>
				<p class="mt-3 mb-3 text-muted">&copy; 2017 & 2022</p>
			</form>
		</main>
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