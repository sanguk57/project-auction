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
					<h2>경매 상품 수정</h2>
					<p class="mb-0">입찰이 시작되기 전까지만 수정할 수 있습니다.</p>
				</div>
			</div>
		</div>

		<section class="ma-section">
			<div class="container">
				<%-- 입력칸 · 검사 · 미리보기는 등록 / 수정이 같은 화면을 쓴다 --%>
				<%@ include file="/WEB-INF/views/include/productForm.jsp"%>
			</div>
		</section>
	</main>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
	<script src="/web/js/productForm.js?v=<%=System.currentTimeMillis() %>"></script>
</body>
</html>
