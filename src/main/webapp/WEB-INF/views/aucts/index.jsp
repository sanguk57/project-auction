<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!DOCTYPE html>
<body>
	<%@ include file="/WEB-INF/views/include/header.jsp"%>

	<!-- ======= 검색 ======= -->
	<section id="hero" class="hero ma-hero">
		<div class="container">
			<div class="row">
				<div class="col-lg-9">
					<h2 data-aos="fade-up">필요한 물건을<br><em>원하는 가격</em>에 낙찰받으세요</h2>
					<p class="lead-text" data-aos="fade-up" data-aos-delay="100">상품명이나 카테고리로 지금 진행 중인 경매를 찾아보세요.</p>

					<form action="index" method="get" class="form-search d-flex align-items-stretch" data-aos="fade-up" data-aos-delay="200">
						<i class="bi bi-search"></i>
						<input type="text" name="value" class="form-control" placeholder="예) 아이패드, 디지털, 패딩" value="${fn:escapeXml(param.value)}">
						<button type="submit" class="btn btn-primary">검색</button>
					</form>

					<div class="ma-hero-stats" data-aos="fade-up" data-aos-delay="300">
						<a href="index"><i class="bi bi-grid"></i>전체 경매 <strong>${cntMap.productCnt}</strong></a>
						<c:if test="${user != null}">
							<a href="index?key=A"><i class="bi bi-box-seam"></i>내 등록 상품 <strong>${cntMap.userProductCnt}</strong></a>
							<a href="index?key=B"><i class="bi bi-heart"></i>관심 상품 <strong id="concernCount">${cntMap.concernCnt}</strong></a>
							<span class="stat"><i class="bi bi-chat-dots"></i>내가 쓴 문의 <strong>${cntMap.userBoardCnt}</strong></span>
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</section>

	<main id="main">
		<!-- ======= 상품 목록 ======= -->
		<section class="ma-section" id="service">
			<div class="container">
				<c:set var="listPath" value="index" />
				<c:set var="showSearch" value="false" />
				<%@ include file="/WEB-INF/views/include/productGrid.jsp"%>
			</div>
		</section>

		<!-- ======= 이용 안내 ======= -->
		<section class="ma-section pt-0">
			<div class="container">
				<div class="ma-section-head"><h2>이렇게 이용해요</h2></div>
				<div class="row g-4 ma-steps">
					<div class="col-lg-4" data-aos="fade-up">
						<div class="ma-step">
							<span class="num">STEP 1</span>
							<div class="ico"><i class="bi bi-person-plus"></i></div>
							<h4>회원가입 후 로그인</h4>
							<p>회원만 입찰 · 찜 · 문의 댓글을 남길 수 있습니다.</p>
							<a href="${user == null ? '/web/users/agree' : '#service'}">${user == null ? '회원가입하기' : '상품 둘러보기'} <i class="bi bi-arrow-right"></i></a>
						</div>
					</div>
					<div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
						<div class="ma-step">
							<span class="num">STEP 2</span>
							<div class="ico"><i class="bi bi-hammer"></i></div>
							<h4>마음에 드는 상품에 입찰</h4>
							<p>현재가 + 입찰 단위 이상으로 입찰하면 최고 입찰자가 됩니다.</p>
							<a href="#service">경매 상품 보기 <i class="bi bi-arrow-right"></i></a>
						</div>
					</div>
					<div class="col-lg-4" data-aos="fade-up" data-aos-delay="200">
						<div class="ma-step">
							<span class="num">STEP 3</span>
							<div class="ico"><i class="bi bi-camera"></i></div>
							<h4>내 물건을 경매에 등록</h4>
							<p>시작가, 입찰 단위, 경매 기간을 정하고 사진과 함께 올리세요.</p>
							<a href="${user == null ? '/web/users/login' : '/web/aucts/productEnrollment'}">상품 등록하기 <i class="bi bi-arrow-right"></i></a>
						</div>
					</div>
				</div>

				<div class="ma-cta mt-5" data-aos="zoom-in">
					<div>
						<h3>안 쓰는 물건, 경매로 팔아보세요</h3>
						<p>사진 몇 장과 시작 가격만 정하면 바로 경매를 시작할 수 있습니다.</p>
					</div>
					<a class="btn" href="${user == null ? '/web/users/login' : '/web/aucts/productEnrollment'}"><i class="bi bi-plus-lg"></i> 경매 상품 등록하기</a>
				</div>
			</div>
		</section>

		<!-- ======= 자주 묻는 질문 ======= -->
		<section id="faq" class="faq">
			<div class="container" data-aos="fade-up">

				<div class="ma-section-head"><h2>자주 묻는 질문</h2></div>

				<div class="row" data-aos="fade-up" data-aos-delay="200">
					<div class="col-12">
						<div class="accordion accordion-flush" id="faqlist">

							<div class="accordion-item">
								<h3 class="accordion-header">
									<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq-content-1">
										<i class="bi bi-question-circle question-icon"></i> 최소 입찰 금액은 어떻게 정해지나요?
									</button>
								</h3>
								<div id="faq-content-1" class="accordion-collapse collapse" data-bs-parent="#faqlist">
									<div class="accordion-body">현재 경매가에 판매자가 정한 입찰 단위를 더한 금액부터 입찰할 수 있습니다.
										상세 화면의 "최소 가격 입찰" 버튼을 누르면 그 금액으로 바로 입찰됩니다.</div>
								</div>
							</div>

							<div class="accordion-item">
								<h3 class="accordion-header">
									<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq-content-2">
										<i class="bi bi-question-circle question-icon"></i> 다른 사람과 동시에 입찰하면 어떻게 되나요?
									</button>
								</h3>
								<div id="faq-content-2" class="accordion-collapse collapse" data-bs-parent="#faqlist">
									<div class="accordion-body">먼저 처리된 입찰 하나만 반영되고, 나머지는 "다른 사람이 먼저 입찰했습니다" 안내가 나옵니다.
										새로고침해서 바뀐 현재가를 확인한 뒤 다시 입찰해주세요.</div>
								</div>
							</div>

							<div class="accordion-item">
								<h3 class="accordion-header">
									<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq-content-3">
										<i class="bi bi-question-circle question-icon"></i> 등록한 상품을 수정하거나 삭제할 수 있나요?
									</button>
								</h3>
								<div id="faq-content-3" class="accordion-collapse collapse" data-bs-parent="#faqlist">
									<div class="accordion-body">아직 입찰이 한 건도 없을 때만 가능합니다.
										입찰이 시작된 뒤에는 입찰자를 보호하기 위해 수정·삭제가 막힙니다.</div>
								</div>
							</div>

							<div class="accordion-item">
								<h3 class="accordion-header">
									<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq-content-4">
										<i class="bi bi-question-circle question-icon"></i> 내가 올린 상품에도 입찰할 수 있나요?
									</button>
								</h3>
								<div id="faq-content-4" class="accordion-collapse collapse" data-bs-parent="#faqlist">
									<div class="accordion-body">아니요. 가격을 부풀리는 것을 막기 위해 본인 상품에는 입찰할 수 없습니다.</div>
								</div>
							</div>

							<div class="accordion-item">
								<h3 class="accordion-header">
									<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq-content-5">
										<i class="bi bi-question-circle question-icon"></i> 어떤 사진을 올릴 수 있나요?
									</button>
								</h3>
								<div id="faq-content-5" class="accordion-collapse collapse" data-bs-parent="#faqlist">
									<div class="accordion-body">jpg, png, gif 이미지를 한 장당 20MB 까지, 여러 장 올릴 수 있습니다.</div>
								</div>
							</div>

						</div>
					</div>
				</div>

			</div>
		</section>
		<!-- End 자주 묻는 질문 -->

	</main>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
	<script src="/web/js/productList.js?v=<%=System.currentTimeMillis() %>"></script>
</body>
</html>
