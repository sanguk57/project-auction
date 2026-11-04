<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<body>
	<header id="header" class="header d-flex align-items-center fixed-top">
		<div
			class="container-fluid container-xl d-flex align-items-center justify-content-between">
			<a href="/web/aucts/index" class="logo d-flex align-items-center">
				<h1><i class="bi bi-hammer"></i>MyAuct</h1>
			</a> <i class="mobile-nav-toggle mobile-nav-show bi bi-list"></i> <i
				class="mobile-nav-toggle mobile-nav-hide d-none bi bi-x"></i>
			<nav id="navbar" class="navbar">
				<ul>
					<li><a href="/web/aucts/index">홈</a></li>
					<li><a href="/web/aucts/about">전체 경매</a></li>
					<li><a href="${user == null ? '/web/users/login' : '/web/aucts/productEnrollment'}">상품 등록</a></li>
					<c:choose>
						<c:when test="${user.name != null}">
							<li class="btn btn-outline-primary dropdown ms-3">
							<span><c:out value="${user.name}" />님</span>
								<ul class="dropdown-menu">
									<li><a class="dropdown-item" href="/web/my"><i class="bi bi-person-circle me-1"></i>마이페이지</a></li>
									<li><a class="dropdown-item" href="/web/my?tab=bids">내 입찰 내역</a></li>
									<li><a class="dropdown-item" href="/web/aucts/index?key=A">내 등록 상품</a></li>
									<li><a class="dropdown-item" href="/web/aucts/index?key=B">관심 상품</a></li>
									<li><a class="dropdown-item" href="/web/aucts/productEnrollment">상품 등록</a></li>
									<li><a class="dropdown-item" href="/web/users/logout">로그아웃</a></li>
								</ul></li>
						</c:when>
						<c:otherwise>
							<li><a class="get-a-quote " href="/web/users/login">로그인</a></li>
						</c:otherwise>
					</c:choose>
					<li><a class="active" id="nowDate"></a></li>
				</ul>
			</nav>
			<!-- .navbar -->

		</div>
	</header>
	<!-- End Header -->

	<%-- 서버에서 보낸 오류 메시지(입력값 오류, 권한 없음 등)를 alert 로 표시 --%>
	<c:if test="${not empty errorMsg}">
		<div id="serverErrorMsg" style="display: none"><c:out value="${errorMsg}" /></div>
		<script>
			window.addEventListener("load", function () {
				alert(document.getElementById("serverErrorMsg").textContent);
			});
		</script>
	</c:if>


</body>
</html>
