<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<body>
	<footer id="footer" class="footer">
		<div class="container">
			<div class="row gy-4">
				<div class="col-lg-6 col-md-12 footer-info">
					<a href="/web/aucts/index" class="logo d-flex align-items-center"> <span>MyAuct</span>
					</a>
					<p>안 쓰는 물건은 경매로 팔고, 필요한 물건은 원하는 가격에 입찰하는 중고 경매 사이트입니다.</p>
				</div>

				<div class="col-lg-3 col-6 footer-links">
					<h4>바로가기</h4>
					<ul>
						<li><a href="/web/aucts/index">홈</a></li>
						<li><a href="/web/aucts/about">전체 경매</a></li>
						<li><a href="/web/aucts/productEnrollment">상품 등록</a></li>
					</ul>
				</div>

				<div class="col-lg-3 col-6 footer-links">
					<h4>회원</h4>
					<ul>
						<li><a href="/web/users/login">로그인</a></li>
						<li><a href="/web/users/agree">회원가입</a></li>
						<li><a href="/web/aucts/index?key=B">관심 상품</a></li>
					</ul>
				</div>
			</div>
		</div>

		<div class="container mt-4">
			<div class="copyright">
				&copy; <strong><span>MyAuct</span></strong> 개인 포트폴리오 프로젝트
			</div>
			<div class="credits">
				<!-- 무료 템플릿(Logis) 라이선스 조건: 이 출처 링크는 지우면 안 됨 (https://bootstrapmade.com/license/) -->
				Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a>
			</div>
		</div>

	</footer>
	<!-- End Footer -->

	<a href="#"
		class="scroll-top d-flex align-items-center justify-content-center"><i
		class="bi bi-arrow-up-short"></i></a>

	<div id="preloader"></div>

	<!-- Vendor JS Files -->
	<script src="/web/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="/web/vendor/purecounter/purecounter_vanilla.js"></script>
	<script src="/web/vendor/glightbox/js/glightbox.min.js"></script>
	<script src="/web/vendor/swiper/swiper-bundle.min.js"></script>
	<script src="/web/vendor/aos/aos.js"></script>
  	<script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
	<!-- Template Main JS File -->
	<script src="/web/js/jquery.datetimepicker.full.min.js"></script>
	<script src="/web/js/main.js?v=<%=System.currentTimeMillis() %>" defer="defer"></script>
	<script src="/web/js/autocomplete.js?v=<%=System.currentTimeMillis() %>"></script>
</body>
</html>
