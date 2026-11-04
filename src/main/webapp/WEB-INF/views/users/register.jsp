<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원가입 - MyAuct</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet"
	integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
<%@ include file="/WEB-INF/views/include/authHead.jsp"%>
</head>

<body class="ma-auth wide">
	<div class="ma-auth-wrap">
		<a class="ma-auth-logo" href="/web/aucts/index"><i class="bi bi-hammer"></i>MyAuct</a>

		<ol class="ma-steps-bar">
			<li class="done"><span><i class="bi bi-check-lg"></i></span>약관 동의</li>
			<li class="on"><span>2</span>정보 입력</li>
			<li><span>3</span>가입 완료</li>
		</ol>

		<%-- 서버에서 되돌아왔을 때 입력했던 값 (비밀번호 제외) --%>
		<c:set var="f" value="${form}" />

		<form class="ma-auth-card ma-reg" action="${path}/users/userCreate" method="post" id="registerForm" novalidate>
			<c:if test="${not empty errorMsg}">
				<div class="alert alert-danger d-flex gap-2 align-items-center" role="alert">
					<i class="bi bi-exclamation-circle"></i><c:out value="${errorMsg}" />
				</div>
			</c:if>

			<!-- 계정 정보 -->
			<h2 class="ma-reg-title"><i class="bi bi-shield-lock"></i>계정 정보</h2>

			<div class="mb-3">
				<label for="user_id" class="form-label">아이디 <em>*</em></label>
				<div class="input-group has-validation">
					<input type="text" class="form-control" id="user_id" name="user_id" maxlength="12" autocomplete="username"
						placeholder="영문 + 숫자 8~12자" value="${fn:escapeXml(f.user_id)}">
					<button type="button" class="btn btn-light-ma" id="idCheckBtn">중복 확인</button>
				</div>
				<div class="ma-msg" data-for="user_id"></div>
			</div>

			<div class="mb-2">
				<label for="password" class="form-label d-flex justify-content-between">
					<span>비밀번호 <em>*</em></span>
					<button type="button" class="ma-eye" id="pwToggle" aria-label="비밀번호 보기"><i class="bi bi-eye"></i> 보기</button>
				</label>
				<input type="password" class="form-control" id="password" name="password" autocomplete="new-password"
					placeholder="영문 · 숫자 · 특수문자 포함 8자 이상">
				<ul class="ma-rules" id="pwRules">
					<li data-rule="len">8자 이상</li>
					<li data-rule="alpha">영문</li>
					<li data-rule="digit">숫자</li>
					<li data-rule="special">특수문자 (@$!%*#?&amp;)</li>
				</ul>
			</div>

			<div class="mb-3">
				<label for="password2" class="form-label">비밀번호 확인 <em>*</em></label>
				<input type="password" class="form-control" id="password2" autocomplete="new-password" placeholder="비밀번호를 한 번 더 입력">
				<div class="ma-msg" data-for="password2"></div>
			</div>

			<!-- 기본 정보 -->
			<h2 class="ma-reg-title"><i class="bi bi-person"></i>기본 정보</h2>

			<div class="row g-3 mb-3">
				<div class="col-sm-6">
					<label for="name" class="form-label">이름 <em>*</em></label>
					<input type="text" class="form-control" id="name" name="name" maxlength="30" autocomplete="name"
						placeholder="홍길동" value="${fn:escapeXml(f.name)}">
					<div class="ma-msg" data-for="name"></div>
				</div>
				<div class="col-sm-6">
					<label for="birth" class="form-label">생년월일 <em>*</em></label>
					<input type="date" class="form-control" id="birth" name="birth" value="${fn:escapeXml(birth)}">
					<div class="ma-msg" data-for="birth"></div>
				</div>
			</div>

			<div class="mb-3">
				<span class="form-label d-block">성별 <span class="opt">선택</span></span>
				<div class="ma-seg">
					<input type="radio" class="btn-check" name="gender" id="g_m" value="남자" ${f.gender == '남자' ? 'checked' : ''}>
					<label for="g_m">남자</label>
					<input type="radio" class="btn-check" name="gender" id="g_f" value="여자" ${f.gender == '여자' ? 'checked' : ''}>
					<label for="g_f">여자</label>
					<input type="radio" class="btn-check" name="gender" id="g_x" value="" ${f.gender != '남자' && f.gender != '여자' ? 'checked' : ''}>
					<label for="g_x">선택 안 함</label>
				</div>
			</div>

			<!-- 연락처 -->
			<h2 class="ma-reg-title"><i class="bi bi-telephone"></i>연락처</h2>

			<div class="row g-3 mb-3">
				<div class="col-sm-6">
					<label for="phone" class="form-label">휴대폰 번호 <em>*</em></label>
					<input type="tel" class="form-control" id="phone" name="phone" maxlength="13" autocomplete="tel"
						placeholder="010-1234-5678" value="${fn:escapeXml(f.phone)}">
					<div class="ma-msg" data-for="phone"></div>
				</div>
				<div class="col-sm-6">
					<label for="email" class="form-label">이메일 <span class="opt">선택</span></label>
					<input type="email" class="form-control" id="email" name="email" maxlength="100" autocomplete="email"
						placeholder="you@example.com" value="${fn:escapeXml(f.email)}">
					<div class="ma-msg" data-for="email"></div>
				</div>
			</div>

			<div class="mb-4">
				<label for="roadFullAddr" class="form-label">주소 <span class="opt">선택</span></label>
				<div class="input-group">
					<input type="text" class="form-control" id="roadFullAddr" name="addr" maxlength="200"
						placeholder="주소 검색 또는 직접 입력" value="${fn:escapeXml(f.addr)}">
					<button type="button" class="btn btn-light-ma" id="addrBtn"><i class="bi bi-search"></i> 주소 검색</button>
				</div>
			</div>

			<p class="ma-fhint mb-3"><i class="bi bi-info-circle"></i> 아이디와 휴대폰 번호는 아이디 · 비밀번호 찾기에 사용됩니다.</p>
			<button type="submit" class="btn btn-lg btn-primary w-100" id="submitBtn">가입하기</button>
			<p class="text-center small text-muted mt-3 mb-0">이미 회원이신가요? <a href="${path}/users/login">로그인</a></p>
		</form>
	</div>

	<script src="${path}/js/register.js?v=<%=System.currentTimeMillis() %>"></script>
</body>
</html>
