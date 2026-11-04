<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!DOCTYPE html>
<body>
	<%@ include file="/WEB-INF/views/include/header.jsp"%>

	<main id="main">
		<div class="breadcrumbs">
			<div class="page-header d-flex align-items-center">
				<div class="container position-relative">
					<h2>전체 경매</h2>
					<p class="mb-0">등록된 모든 경매 상품을 한 번에 둘러보세요. 진행 중인 경매가 먼저 보입니다.</p>
				</div>
			</div>
		</div>

		<section class="ma-section">
			<div class="container">
				<c:set var="listPath" value="about" />
				<c:set var="showSearch" value="true" />
				<%@ include file="/WEB-INF/views/include/productGrid.jsp"%>
			</div>
		</section>
	</main>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
	<script src="/web/js/productList.js?v=<%=System.currentTimeMillis() %>"></script>
</body>
</html>
