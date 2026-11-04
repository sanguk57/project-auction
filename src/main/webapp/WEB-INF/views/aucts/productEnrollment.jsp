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
					<h2>경매 상품 등록</h2>
					<p class="mb-0">사진과 시작 가격, 경매 기간을 정하면 바로 경매가 시작됩니다.</p>
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
