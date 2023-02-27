<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous">
<style>
</style>
</head>

<body>
	<div
		class="container d-flex justify-content-center align-items-center mt-5">
		<form class="row g-3 text-start w-50 h-50 mx-auto"
			action="${path}/users/userCreate" method="post" name="form" id="form">
			<div class="col-md-9">
				<label for="inputId" class="form-label ">아이디*</label> <input
					type="text" name="user_id" class="form-control id" id="inputText"
					placeholder="영문(대,소), 숫자 포함  8~12자리">
				<p class="invalid-feedback id_ck m-0"></p>
				<p class="valid-feedback m-0"></p>
			</div>

			<div
				class="col-md-3 d-flex justify-content-center align-items-center">
				<button type="button" class="btn btn-lg btn-primary w-100  btn_idck">중복확인</button>
			</div>


			<div class="col-md-12">
				<label for="inputPassword" class="form-label">비밀번호* 확인</label> <input
					class="form-check-input me-3 btn_pwck" type="checkbox"
					id="flexRadioDefault1"> <input
					type="password" class="form-control pw" id="inputPassword" name="password"
					placeholder="영문(대, 소), 특수문자, 숫자 1개 이상포함 8자리이상">
				<p class="invalid-feedback pw_ck m-0"></p>
			</div>

			<div class="col-12">
				<label for="inputPassword" class="form-label">비밀번호* 재확인</label> <input
					type="password" class="form-control pw_rs" id="inputPassword">
				<p class="invalid-feedback pwrs_ck"></p>
			</div>
			<div class="col-12">
				<label for="name" class="form-label">이름*</label> <input type="text"
					class="form-control name" name="name" id="inputText"
					placeholder="한글, 영문이름">
				<p class="invalid-feedback name_ck"></p>
			</div>

			<div class="col-12">
				<button type="button"
					class="btn btn-sm btn-primary w-25 align-items-end"
					onclick="javascript:goPopup();">주소검색</button>
			 	<input type="text" class="form-control" placeholder="기본 주소를 입력해 주세요" id="roadFullAddr" name="addr">
			</div>

			<div class="col-md-12">
				<label for="inputCity" class="form-label">생년월일</label> <input
					type="date" class="form-control" name="birth" id="inputDate">
			</div>

			<div class="col-md-12">
				<label for="inputState" class="form-label">성별</label> <select
					id="inputState" class="form-select" name="gender">
					<option selected>성별</option>
					<option>남자</option>
					<option>여자</option>
				</select>
			</div>
			<div class="col-md-12">
				<label for="inputId" class="form-label">계정확인 메일</label> <input
					type="email" class="form-control email" id="inputEmail"
					name="email">
				<p class="invalid-feedback email_ck m-0"></p>
			</div>
			<div class="col-md-9">
				<label for="inputId" class="form-label">전화번호*</label> <input
					type="tel" class="form-control tel_num" name="phone" id="inputTel"
					placeholder="핸드폰 번호">
			</div>
			<div class="col-md-3 d-flex justify-content-center align-items-end">
				<button type="button" class="btn btn-lg btn-primary w-100  btn_phCk">본인인증</button>
			</div>

			<div class="col-md-12">
				<input type="text" class="form-control ok_num" id="inputNum"
					placeholder="인증번호">
			</div>
			<div class="col-12">
				<button type="submit"
					class="btn btn-lg btn-primary w-100 btn_sm p-0">가입하기</button>
			</div>
		</form>
	</div>
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
	<script src="${path}/js/register.js?v=<%=System.currentTimeMillis() %>"
		defer></script>
</body>

</html>
