<%@page import="com.myauct.web.domain.auctmaster.dto.AuctMasterDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.apache.ibatis.reflection.SystemMetaObject"%>
<%@page import="java.util.List"%>
<%@page import="org.springframework.ui.Model"%>
<%@page import="com.myauct.web.domain.auctmaster.dto.AuctFileUploadDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<%
List<Integer> anumList = new ArrayList<>();
List<AuctMasterDTO> List = (List<AuctMasterDTO>) request.getAttribute("productList");
for (AuctMasterDTO dto : List) {
	anumList.add(dto.getAnum());
}
%>
<c:set var="anum" value="<%=anumList%>" />
<!DOCTYPE html>
<style>
.btn_like {
	position: relative;
	margin: 100px auto;
	display: block;
	width: 44px;
	height: 44px;
	border: 1px solid #e8e8e8;
	border-radius: 44px;
	font-family: notokr-bold, sans-serif;
	font-size: 14px;
	line-height: 16px;
	background-color: #fff;
	color: #DD5D54;
	box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.03);
	transition: border .2s ease-out, box-shadow .1s ease-out,
		background-color .4s ease-out;
	cursor: pointer;
}

.btn_like:hover {
	border: 1px solid rgba(228, 89, 89, 0.3);
	background-color: rgba(228, 89, 89, 0.02);
	box-shadow: 0 2px 4px 0 rgba(228, 89, 89, 0.2);
}

.btn_unlike .img_emoti {
	background-position: -30px -120px;
}

.img_emoti {
	display: inline-block;
	overflow: hidden;
	font-size: 0;
	line-height: 0;
	background:
		url(https://mk.kakaocdn.net/dn/emoticon/static/images/webstore/img_emoti.png?v=20180410)
		no-repeat;
	text-indent: -9999px;
	vertical-align: top;
	width: 20px;
	height: 17px;
	margin-top: 1px;
	background-position: 0px -120px;
	text-indent: 0;
}

.btn_like .ani_heart_m {
	margin: -63px 0 0 -63px;
}

.ani_heart_m {
	display: block;
	position: absolute;
	top: 50%;
	left: 50%;
	width: 125px;
	height: 125px;
	margin: -63px 0 0 -63px;
	pointer-events: none;
}

.ani_heart_m.hi {
	background-image:
		url(https://mk.kakaocdn.net/dn/emoticon/static/images/webstore/retina/zzim_on_m.png);
	-webkit-background-size: 9000px 125px;
	background-size: 9000px 125px;
	animation: on_m 1.06s steps(72);
}

.ani_heart_m.bye {
	background-image:
		url(https://mk.kakaocdn.net/dn/emoticon/static/images/webstore/retina/zzim_off_m.png);
	-webkit-background-size: 8250px 125px;
	background-size: 8250px 125px;
	animation: off_m 1.06s steps(66);
}

@
keyframes on_m {from { background-position:0
	
}

to {
	background-position: -9000px
}

}
@
keyframes off_m {from { background-position:0
	
}

to {
	background-position: -8250px
}

}
.swiper-slide {
	width: 19rem;
	height: 10.688rem;
}

.swiper-slide img {
	display: block;
	width: 19rem;
	height: 10.688rem;
	object-fit: cover;
}
</style>
<body>
	<!-- ======= Header ======= -->
	<%@ include file="/WEB-INF/views/include/header.jsp"%>
	<!-- End Header -->

	<!-- ======= Hero Section ======= -->
	<section id="hero" class="hero d-flex align-items-center">
		<div class="container">
			<div class="row gy-4 d-flex justify-content-between">
				<div
					class="col-lg-6 order-2 order-lg-1 d-flex flex-column justify-content-center">
					<h2 data-aos="fade-up">경매 물품 검색</h2>
					<p data-aos="fade-up" data-aos-delay="100"></p>

					<form action="index" method="get"
						class="form-search d-flex align-items-stretch mb-3"
						data-aos="fade-up" data-aos-delay="200">
						<input type="text" name="value" class="form-control"
							placeholder="물품 or 카테고리">
						<button type="submit" class="btn btn-primary">Search</button>
					</form>

					<div class="row gy-4" data-aos="fade-up" data-aos-delay="400">
						<div class="col-lg-3 col-6">
							<div class="stats-item text-center w-100 h-100">
								<span data-purecounter-start="0"
									data-purecounter-end="${cntMap.productCnt}"
									data-purecounter-duration="2" class="purecounter"></span>
								<c:if test="${param.value==null}">
									<p>총 경매 수</p>
								</c:if>
								<c:if test="${param.value != null}">
									<p>${param.value}관련경매수</p>
								</c:if>
							</div>
						</div>
						<!-- End Stats Item -->

						<c:if test="${user != null}">
							<div class="col-lg-3 col-6">
								<div class="stats-item text-center w-100 h-100">
									<a href="index?key=A" style="color: white"> <span
										data-purecounter-start="0"
										data-purecounter-end="${cntMap.userProductCnt}"
										data-purecounter-duration="2" class="purecounter"></span>
									</a>
									<p>내 경매품 수</p>
								</div>
							</div>
						</c:if>
						<!-- End Stats Item -->

						<c:if test="${user != null}">
							<div class="col-lg-3 col-6">
								<div class="stats-item text-center w-100 h-100">
									<a href="index?key=B" style="color: white"> <span
										data-purecounter-start="0"
										data-purecounter-end="${cntMap.concernCnt}"
										data-purecounter-duration="2" class="purecounter"></span>
									</a>
									<p>관심 목록</p>
								</div>
							</div>
						</c:if>
						<!-- End Stats Item -->

						<c:if test="${user != null}">
							<div class="col-lg-3 col-6">
								<div class="stats-item text-center w-100 h-100">
									<span data-purecounter-start="0"
										data-purecounter-end="${cntMap.userBoardCnt}"
										data-purecounter-duration="2" class="purecounter"></span>
									<p>내 경매품 댓글수</p>
								</div>
							</div>
						</c:if>
						<!-- End Stats Item -->

					</div>
				</div>

				<div class="col-lg-5 order-1 order-lg-2 hero-img"
					data-aos="zoom-out">
					<img src="/web/images/hero-img.svg" class="img-fluid mb-3 mb-lg-0"
						alt="">
				</div>
			</div>
		</div>
	</section>
	<!-- End Hero Section -->

	<main id="main">
		<!-- ======= Services Section ======= -->
		<section id="service" class="services p-0">
			<div class="container" data-aos="fade-up">

				<div class="section-header">
					<span>Auction Service</span>
					<h2>Auction Service</h2>

				</div>

				<div class="row gy-4">
					<c:forEach var="product" items="${productList}" varStatus="i">
						<div class="col-lg-3 col-md-6" data-aos="fade-up"
							data-aos-delay="100">
							<div class="card">
								<div class="card-img card${product.anum} swiper mySwiper">
									<div class="swiper-wrapper"></div>
								</div>
								<h3>
									<a href="/web/aucts/productView?anum=${product.anum}">${i.index}:${product.anum}:${product.unum}:${product.prod_title}</a>
								</h3>
								<p>${product.contents}</p>
								<c:if test="${user != null }">
									<div>
										<button type="button"
											class="btn_like m-auto p-auto btn${product.anum}"
											value="${product.anum}">
											<span class="img_emoti">좋아요</span> <span class="ani_heart_m"></span>
										</button>
									</div>
								</c:if>
							</div>

						</div>
						<!-- End Card Item -->

					</c:forEach>
					<!-- End forEach -->
					<div class="col-md-12 d-flex">
						<div class="col-md-2 mt-3 pt-3 mx-auto">
							<select id="cntPerPage" name="sel" onchange="selChange()"
								class="form-select form-select-sm mx-auto" style="width: 70%"
								aria-label=".form-select-sm example">
								<option value="4"
									<c:if test="${paging.cntPerPage == 4}">selected</c:if>>4개
									보기</option>
								<option value="8"
									<c:if test="${paging.cntPerPage == 8}">selected</c:if>>8개
									보기</option>
								<option value="12"
									<c:if test="${paging.cntPerPage == 12}">selected</c:if>>12개
									보기</option>
								<option value="16"
									<c:if test="${paging.cntPerPage == 16}">selected</c:if>>16개
									보기</option>
							</select>
						</div>
						<div class="col-md-8  mx-auto mt-3 pt-3 ">
							<form action="index" method="get" style="width: 80%"
								class="form-search d-flex align-items-stretch mb-3 mx-auto"
								data-aos="fade-up" data-aos-delay="200">
								<input type="text" name="value" class="form-control"
									placeholder="물품 or 카테고리">
								<button type="submit" class="btn btn-primary">Search</button>
							</form>
						</div>

						<div class="col-md-2  mt-3 pt-3 mx-auto">
							<a class="btn btn-primary px-auto center" style="width: 100%"
								href="<c:if test="${user == null}">/web/users/login</c:if><c:if test="${user != null}">/web/aucts/productEnrollment</c:if>">경매상품
								등록하기</a>
						</div>
					</div>
					<!-- 옵션선택 끝 -->

					<nav aria-label="...">
						<ul class="pagination justify-content-center"">
							<c:if test="${paging.startPage != 1 }">
								<li class="page-item"><a
									href="/web/aucts/index?nowPage=${paging.startPage - 1 }&cntPerPage=${paging.cntPerPage}&value=${param.value}&key=${param.key}"
									class="page-link">Previous</a>
							</c:if>
							<c:forEach begin="${paging.startPage }" end="${paging.endPage }"
								var="p">
								<c:choose>
									<c:when test="${p == paging.nowPage }">
										<li class="page-item active" aria-current="page"><span
											class="page-link">${p}</span></li>
									</c:when>
									<c:when test="${p != paging.nowPage }">
										<li class="page-item"><a class="page-link"
											href="/web/aucts/index?nowPage=${p}&cntPerPage=${paging.cntPerPage}&value=${param.value}&key=${param.key}">${p}</a></li>
									</c:when>
								</c:choose>
							</c:forEach>
							<c:if test="${paging.endPage != paging.lastPage}">
								<li class="page-item"><a class="page-link"
									href="/web/aucts/index?nowPage=${paging.endPage+1}&cntPerPage=${paging.cntPerPage}&value=${param.value}&key=${param.key}">Next</a></li>
							</c:if>
						</ul>
					</nav>
				</div>
			</div>
		</section>
		<!-- End Services Section -->
		<!-- ======= Featured Services Section ======= -->
		<section id="featured-services" class="featured-services">
			<div class="container">

				<div class="row gy-4">

					<div class="col-lg-4 col-md-6 service-item d-flex"
						data-aos="fade-up">
						<div class="icon flex-shrink-0">
							<i class="fa-solid fa-cart-flatbed"></i>
						</div>
						<div>
							<h4 class="title">경매이용 절차</h4>
							<p class="description">사이트 접속후 회원가입</p>
							<a href="${user==null ? '/web/users/login' : '#'}"
								class="readmore stretched-link"><span>Learn More</span><i
								class="bi bi-arrow-right"></i></a>
						</div>
					</div>
					<!-- End Service Item -->

					<div class="col-lg-4 col-md-6 service-item d-flex"
						data-aos="fade-up" data-aos-delay="100">
						<div class="icon flex-shrink-0">
							<i class="fa-solid fa-truck"></i>
						</div>
						<div>
							<h4 class="title">판매하고 싶은 물품 등록</h4>
							<p class="description">상품 등록페이지에서 상품등록</p>
							<a
								href="<c:if test="${user==null}">/web/users/login</c:if><c:if test="${user!=null}">productEnrollment</c:if>"
								class="readmore stretched-link"><span>Learn More</span><i
								class="bi bi-arrow-right"></i></a>
						</div>
					</div>
					<!-- End Service Item -->

					<div class="col-lg-4 col-md-6 service-item d-flex"
						data-aos="fade-up" data-aos-delay="200">
						<div class="icon flex-shrink-0">
							<i class="fa-solid fa-truck-ramp-box"></i>
						</div>
						<div>
							<h4 class="title">문의글 및 에러 사항</h4>
							<p class="description">사이트 이용시 발생한 에러 사항</p>
							<a href="service-details" class="readmore stretched-link"><span>Learn
									More</span><i class="bi bi-arrow-right"></i></a>
						</div>
					</div>
					<!-- End Service Item -->

				</div>

			</div>
		</section>
		<!-- End Featured Services Section -->

		<!-- ======= About Us Section ======= -->
		<section id="about" class="about pt-0">
			<div class="container" data-aos="fade-up">

				<div class="row gy-4">
					<div
						class="col-lg-6 position-relative align-self-start order-lg-last order-first">
						<img src="/web/images/about.jpg" class="img-fluid" alt=""> <a
							href="https://www.youtube.com/watch?v=XE0fBAw6AvY&t=94s"
							class="glightbox play-btn"></a>
					</div>
					<div class="col-lg-6 content order-last  order-lg-first">
						<h3>경매사이트 소개</h3>
						<p>Dolor iure expedita id fuga asperiores qui sunt consequatur
							minima. Quidem voluptas deleniti. Sit quia molestiae quia quas
							qui magnam itaque veritatis dolores. Corrupti totam ut eius
							incidunt reiciendis veritatis asperiores placeat.</p>
						<ul>
							<li data-aos="fade-up" data-aos-delay="100"><i
								class="bi bi-diagram-3"></i>
								<div>
									<h5>Ullamco laboris nisi ut aliquip consequat</h5>
									<p>Magni facilis facilis repellendus cum excepturi quaerat
										praesentium libre trade</p>
								</div></li>
							<li data-aos="fade-up" data-aos-delay="200"><i
								class="bi bi-fullscreen-exit"></i>
								<div>
									<h5>Magnam soluta odio exercitationem reprehenderi</h5>
									<p>Quo totam dolorum at pariatur aut distinctio dolorum
										laudantium illo direna pasata redi</p>
								</div></li>
							<li data-aos="fade-up" data-aos-delay="300"><i
								class="bi bi-broadcast"></i>
								<div>
									<h5>Voluptatem et qui exercitationem</h5>
									<p>Et velit et eos maiores est tempora et quos dolorem
										autem tempora incidunt maxime veniam</p>
								</div></li>
						</ul>
					</div>
				</div>

			</div>
		</section>
		<!-- End About Us Section -->

		<!-- ======= Call To Action Section ======= -->
		<section id="call-to-action" class="call-to-action">
			<div class="container" data-aos="zoom-out">

				<div class="row justify-content-center">
					<div class="col-lg-8 text-center">
						<h3>경매상품 등록하기</h3>
						<p>Duis aute irure dolor in reprehenderit in voluptate velit
							esse cillum dolore eu fugiat nulla pariatur. Excepteur sint
							occaecat cupidatat non proident, sunt in culpa qui officia
							deserunt mollit anim id est laborum.</p>

						<a class="cta-btn"
							href="<c:if test="${user == null}">/web/users/login</c:if><c:if test="${user != null}">/web/aucts/productEnrollment</c:if>">경매상품
							등록하기</a>
					</div>
				</div>

			</div>
		</section>
		<!-- End Call To Action Section -->

		<!-- ======= Features Section ======= -->
		<section id="features" class="features">
			<div class="container">

				<div class="row gy-4 align-items-center features-item"
					data-aos="fade-up">

					<div class="col-md-5">
						<img src="/web/images/features-1.jpg" class="img-fluid" alt="">
					</div>
					<div class="col-md-7">
						<h3>Voluptatem dignissimos provident quasi corporis
							voluptates sit assumenda.</h3>
						<p class="fst-italic">Lorem ipsum dolor sit amet, consectetur
							adipiscing elit, sed do eiusmod tempor incididunt ut labore et
							dolore magna aliqua.</p>
						<ul>
							<li><i class="bi bi-check"></i> Ullamco laboris nisi ut
								aliquip ex ea commodo consequat.</li>
							<li><i class="bi bi-check"></i> Duis aute irure dolor in
								reprehenderit in voluptate velit.</li>
							<li><i class="bi bi-check"></i> Ullam est qui quos
								consequatur eos accusamus.</li>
						</ul>
					</div>
				</div>
				<!-- Features Item -->

				<div class="row gy-4 align-items-center features-item"
					data-aos="fade-up">
					<div class="col-md-5 order-1 order-md-2">
						<img src="/web/images/features-2.jpg" class="img-fluid" alt="">
					</div>
					<div class="col-md-7 order-2 order-md-1">
						<h3>Corporis temporibus maiores provident</h3>
						<p class="fst-italic">Lorem ipsum dolor sit amet, consectetur
							adipiscing elit, sed do eiusmod tempor incididunt ut labore et
							dolore magna aliqua.</p>
						<p>Ullamco laboris nisi ut aliquip ex ea commodo consequat.
							Duis aute irure dolor in reprehenderit in voluptate velit esse
							cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
							cupidatat non proident, sunt in culpa qui officia deserunt mollit
							anim id est laborum</p>
					</div>
				</div>
				<!-- Features Item -->

				<div class="row gy-4 align-items-center features-item"
					data-aos="fade-up">
					<div class="col-md-5">
						<img src="/web/images/features-3.jpg" class="img-fluid" alt="">
					</div>
					<div class="col-md-7">
						<h3>Sunt consequatur ad ut est nulla consectetur reiciendis
							animi voluptas</h3>
						<p>Cupiditate placeat cupiditate placeat est ipsam culpa.
							Delectus quia minima quod. Sunt saepe odit aut quia voluptatem
							hic voluptas dolor doloremque.</p>
						<ul>
							<li><i class="bi bi-check"></i> Ullamco laboris nisi ut
								aliquip ex ea commodo consequat.</li>
							<li><i class="bi bi-check"></i> Duis aute irure dolor in
								reprehenderit in voluptate velit.</li>
							<li><i class="bi bi-check"></i> Facilis ut et voluptatem
								aperiam. Autem soluta ad fugiat.</li>
						</ul>
					</div>
				</div>
				<!-- Features Item -->

				<div class="row gy-4 align-items-center features-item"
					data-aos="fade-up">
					<div class="col-md-5 order-1 order-md-2">
						<img src="/web/images/features-4.jpg" class="img-fluid" alt="">
					</div>
					<div class="col-md-7 order-2 order-md-1">
						<h3>Quas et necessitatibus eaque impedit ipsum animi
							consequatur incidunt in</h3>
						<p class="fst-italic">Lorem ipsum dolor sit amet, consectetur
							adipiscing elit, sed do eiusmod tempor incididunt ut labore et
							dolore magna aliqua.</p>
						<p>Ullamco laboris nisi ut aliquip ex ea commodo consequat.
							Duis aute irure dolor in reprehenderit in voluptate velit esse
							cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
							cupidatat non proident, sunt in culpa qui officia deserunt mollit
							anim id est laborum</p>
					</div>
				</div>
				<!-- Features Item -->

			</div>
		</section>
		<!-- End Features Section -->

		<!-- ======= Pricing Section ======= -->
		<section id="pricing" class="pricing pt-0">
			<div class="container" data-aos="fade-up">

				<div class="section-header">
					<span>Pricing</span>
					<h2>Pricing</h2>

				</div>

				<div class="row gy-4">

					<div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
						<div class="pricing-item">
							<h3>Free Plan</h3>
							<h4>
								<sup>$</sup>0<span> / month</span>
							</h4>
							<ul>
								<li><i class="bi bi-check"></i> Quam adipiscing vitae proin</li>
								<li><i class="bi bi-check"></i> Nec feugiat nisl pretium</li>
								<li><i class="bi bi-check"></i> Nulla at volutpat diam
									uteera</li>
								<li class="na"><i class="bi bi-x"></i> <span>Pharetra
										massa massa ultricies</span></li>
								<li class="na"><i class="bi bi-x"></i> <span>Massa
										ultricies mi quis hendrerit</span></li>
							</ul>
							<a href="#" class="buy-btn">Buy Now</a>
						</div>
					</div>
					<!-- End Pricing Item -->

					<div class="col-lg-4" data-aos="fade-up" data-aos-delay="200">
						<div class="pricing-item featured">
							<h3>Business Plan</h3>
							<h4>
								<sup>$</sup>29<span> / month</span>
							</h4>
							<ul>
								<li><i class="bi bi-check"></i> Quam adipiscing vitae proin</li>
								<li><i class="bi bi-check"></i> Nec feugiat nisl pretium</li>
								<li><i class="bi bi-check"></i> Nulla at volutpat diam
									uteera</li>
								<li><i class="bi bi-check"></i> Pharetra massa massa
									ultricies</li>
								<li><i class="bi bi-check"></i> Massa ultricies mi quis
									hendrerit</li>
							</ul>
							<a href="#" class="buy-btn">Buy Now</a>
						</div>
					</div>
					<!-- End Pricing Item -->

					<div class="col-lg-4" data-aos="fade-up" data-aos-delay="300">
						<div class="pricing-item">
							<h3>Developer Plan</h3>
							<h4>
								<sup>$</sup>49<span> / month</span>
							</h4>
							<ul>
								<li><i class="bi bi-check"></i> Quam adipiscing vitae proin</li>
								<li><i class="bi bi-check"></i> Nec feugiat nisl pretium</li>
								<li><i class="bi bi-check"></i> Nulla at volutpat diam
									uteera</li>
								<li><i class="bi bi-check"></i> Pharetra massa massa
									ultricies</li>
								<li><i class="bi bi-check"></i> Massa ultricies mi quis
									hendrerit</li>
							</ul>
							<a href="#" class="buy-btn">Buy Now</a>
						</div>
					</div>
					<!-- End Pricing Item -->

				</div>

			</div>
		</section>
		<!-- End Pricing Section -->

		<!-- ======= Testimonials Section ======= -->
		<section id="testimonials" class="testimonials">
			<div class="container">

				<div class="slides-1 swiper" data-aos="fade-up">
					<div class="swiper-wrapper">

						<div class="swiper-slide">
							<div class="testimonial-item">
								<img src="/web/images/testimonials/testimonials-1.jpg"
									class="testimonial-img" alt="">
								<h3>Saul Goodman</h3>
								<h4>Ceo &amp; Founder</h4>
								<div class="stars">
									<i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
										class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
										class="bi bi-star-fill"></i>
								</div>
								<p>
									<i class="bi bi-quote quote-icon-left"></i> Proin iaculis purus
									consequat sem cure digni ssim donec porttitora entum suscipit
									rhoncus. Accusantium quam, ultricies eget id, aliquam eget nibh
									et. Maecen aliquam, risus at semper. <i
										class="bi bi-quote quote-icon-right"></i>
								</p>
							</div>
						</div>
						<!-- End testimonial item -->

						<div class="swiper-slide">
							<div class="testimonial-item">
								<img src="/web/images/testimonials/testimonials-2.jpg"
									class="testimonial-img" alt="">
								<h3>Sara Wilsson</h3>
								<h4>Designer</h4>
								<div class="stars">
									<i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
										class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
										class="bi bi-star-fill"></i>
								</div>
								<p>
									<i class="bi bi-quote quote-icon-left"></i> Export tempor illum
									tamen malis malis eram quae irure esse labore quem cillum quid
									cillum eram malis quorum velit fore eram velit sunt aliqua
									noster fugiat irure amet legam anim culpa. <i
										class="bi bi-quote quote-icon-right"></i>
								</p>
							</div>
						</div>
						<!-- End testimonial item -->

						<div class="swiper-slide">
							<div class="testimonial-item">
								<img src="/web/images/testimonials/testimonials-3.jpg"
									class="testimonial-img" alt="">
								<h3>Jena Karlis</h3>
								<h4>Store Owner</h4>
								<div class="stars">
									<i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
										class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
										class="bi bi-star-fill"></i>
								</div>
								<p>
									<i class="bi bi-quote quote-icon-left"></i> Enim nisi quem
									export duis labore cillum quae magna enim sint quorum nulla
									quem veniam duis minim tempor labore quem eram duis noster aute
									amet eram fore quis sint minim. <i
										class="bi bi-quote quote-icon-right"></i>
								</p>
							</div>
						</div>
						<!-- End testimonial item -->

						<div class="swiper-slide">
							<div class="testimonial-item">
								<img src="/web/images/testimonials/testimonials-4.jpg"
									class="testimonial-img" alt="">
								<h3>Matt Brandon</h3>
								<h4>Freelancer</h4>
								<div class="stars">
									<i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
										class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
										class="bi bi-star-fill"></i>
								</div>
								<p>
									<i class="bi bi-quote quote-icon-left"></i> Fugiat enim eram
									quae cillum dolore dolor amet nulla culpa multos export minim
									fugiat minim velit minim dolor enim duis veniam ipsum anim
									magna sunt elit fore quem dolore labore illum veniam. <i
										class="bi bi-quote quote-icon-right"></i>
								</p>
							</div>
						</div>
						<!-- End testimonial item -->

						<div class="swiper-slide">
							<div class="testimonial-item">
								<img src="/web/images/testimonials/testimonials-5.jpg"
									class="testimonial-img" alt="">
								<h3>John Larson</h3>
								<h4>Entrepreneur</h4>
								<div class="stars">
									<i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
										class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
										class="bi bi-star-fill"></i>
								</div>
								<p>
									<i class="bi bi-quote quote-icon-left"></i> Quis quorum aliqua
									sint quem legam fore sunt eram irure aliqua veniam tempor
									noster veniam enim culpa labore duis sunt culpa nulla illum
									cillum fugiat legam esse veniam culpa fore nisi cillum quid. <i
										class="bi bi-quote quote-icon-right"></i>
								</p>
							</div>
						</div>
						<!-- End testimonial item -->

					</div>
					<div class="swiper-pagination"></div>
				</div>

			</div>
		</section>
		<!-- End Testimonials Section -->

		<!-- ======= Frequently Asked Questions Section ======= -->
		<section id="faq" class="faq">
			<div class="container" data-aos="fade-up">

				<div class="section-header">
					<span>Frequently Asked Questions</span>
					<h2>Frequently Asked Questions</h2>

				</div>

				<div class="row justify-content-center" data-aos="fade-up"
					data-aos-delay="200">
					<div class="col-lg-10">

						<div class="accordion accordion-flush" id="faqlist">

							<div class="accordion-item">
								<h3 class="accordion-header">
									<button class="accordion-button collapsed" type="button"
										data-bs-toggle="collapse" data-bs-target="#faq-content-1">
										<i class="bi bi-question-circle question-icon"></i> Non
										consectetur a erat nam at lectus urna duis?
									</button>
								</h3>
								<div id="faq-content-1" class="accordion-collapse collapse"
									data-bs-parent="#faqlist">
									<div class="accordion-body">Feugiat pretium nibh ipsum
										consequat. Tempus iaculis urna id volutpat lacus laoreet non
										curabitur gravida. Venenatis lectus magna fringilla urna
										porttitor rhoncus dolor purus non.</div>
								</div>
							</div>
							<!-- # Faq item-->

							<div class="accordion-item">
								<h3 class="accordion-header">
									<button class="accordion-button collapsed" type="button"
										data-bs-toggle="collapse" data-bs-target="#faq-content-2">
										<i class="bi bi-question-circle question-icon"></i> Feugiat
										scelerisque varius morbi enim nunc faucibus a pellentesque?
									</button>
								</h3>
								<div id="faq-content-2" class="accordion-collapse collapse"
									data-bs-parent="#faqlist">
									<div class="accordion-body">Dolor sit amet consectetur
										adipiscing elit pellentesque habitant morbi. Id interdum velit
										laoreet id donec ultrices. Fringilla phasellus faucibus
										scelerisque eleifend donec pretium. Est pellentesque elit
										ullamcorper dignissim. Mauris ultrices eros in cursus turpis
										massa tincidunt dui.</div>
								</div>
							</div>
							<!-- # Faq item-->

							<div class="accordion-item">
								<h3 class="accordion-header">
									<button class="accordion-button collapsed" type="button"
										data-bs-toggle="collapse" data-bs-target="#faq-content-3">
										<i class="bi bi-question-circle question-icon"></i> Dolor sit
										amet consectetur adipiscing elit pellentesque habitant morbi?
									</button>
								</h3>
								<div id="faq-content-3" class="accordion-collapse collapse"
									data-bs-parent="#faqlist">
									<div class="accordion-body">Eleifend mi in nulla posuere
										sollicitudin aliquam ultrices sagittis orci. Faucibus pulvinar
										elementum integer enim. Sem nulla pharetra diam sit amet nisl
										suscipit. Rutrum tellus pellentesque eu tincidunt. Lectus urna
										duis convallis convallis tellus. Urna molestie at elementum eu
										facilisis sed odio morbi quis</div>
								</div>
							</div>
							<!-- # Faq item-->

							<div class="accordion-item">
								<h3 class="accordion-header">
									<button class="accordion-button collapsed" type="button"
										data-bs-toggle="collapse" data-bs-target="#faq-content-4">
										<i class="bi bi-question-circle question-icon"></i> Ac odio
										tempor orci dapibus. Aliquam eleifend mi in nulla?
									</button>
								</h3>
								<div id="faq-content-4" class="accordion-collapse collapse"
									data-bs-parent="#faqlist">
									<div class="accordion-body">
										<i class="bi bi-question-circle question-icon"></i> Dolor sit
										amet consectetur adipiscing elit pellentesque habitant morbi.
										Id interdum velit laoreet id donec ultrices. Fringilla
										phasellus faucibus scelerisque eleifend donec pretium. Est
										pellentesque elit ullamcorper dignissim. Mauris ultrices eros
										in cursus turpis massa tincidunt dui.
									</div>
								</div>
							</div>
							<!-- # Faq item-->

							<div class="accordion-item">
								<h3 class="accordion-header">
									<button class="accordion-button collapsed" type="button"
										data-bs-toggle="collapse" data-bs-target="#faq-content-5">
										<i class="bi bi-question-circle question-icon"></i> Tempus
										quam pellentesque nec nam aliquam sem et tortor consequat?
									</button>
								</h3>
								<div id="faq-content-5" class="accordion-collapse collapse"
									data-bs-parent="#faqlist">
									<div class="accordion-body">Molestie a iaculis at erat
										pellentesque adipiscing commodo. Dignissim suspendisse in est
										ante in. Nunc vel risus commodo viverra maecenas accumsan. Sit
										amet nisl suscipit adipiscing bibendum est. Purus gravida quis
										blandit turpis cursus in</div>
								</div>
							</div>
							<!-- # Faq item-->

						</div>

					</div>
				</div>

			</div>
		</section>
		<!-- End Frequently Asked Questions Section -->

	</main>
	<!-- End #main -->

	<!-- ======= Footer ======= -->
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
	<!-- End Footer -->
	<script type="text/javascript">
	
	$(function(){
		jQuery.ajaxSettings.traditional = true;
		var product = {anum:${anum}} /* 이미지 파일을 찾을 anum 리스트 */
		$.ajax({
		url: '/web/product-api/uploadAjaxAction',
		contentType : "application/json; charset=UTF-8",
		dataType : "json",
    	type : 'POST',
    	data : JSON.stringify(product),
    	success: function(data, textStatus){
	          console.log(data, textStatus);
	         for(var i of ${anum}){
	        		  console.log("anum : "+i)
	        		  /* 클래스 이름에 anum이 포함 되어 있으면 반복 그 클래스에서  */
	          if(i in data) { // anum에 대한 데이터가 있으면 
	        		  console.log(data[i].length)
	        		  console.log()
	        		  for(var j in data[i]){
	        			  console.log(data[i][j])
	        			    $(".card"+i).children('.swiper-wrapper').append("<div class='swiper-slide'><img class='img-thumbnail' src='/web/upload/"+data[i][j]+"' alt='뭐가 없노' class='img-fluid productImg'></div>")
	        		  }
	          }
	         }
	          
	        	   /* console.log(data.key[i]); */
	        	  
	        	  /* <img src="/web/images/storage-service.jpg" alt=""
						class="img-fluid"> */
	        },
	        error: function(data, textStatus){
	         console.log(data.responseText, textStatus)
	         }
	});	 
		$('.btn_like').click(function(event){
			  if($(this).hasClass('btn_unlike')){
			    $(this).removeClass('btn_unlike');
			    $(this).children('.ani_heart_m').removeClass('hi');
			    $(this).children('.ani_heart_m').addClass('bye');
			    	var code = {anum:$(this).val(), unum:${user.unum==null ? 0 : user.unum}}
			    $.ajax({
					url: '/web/product-api/product_unconcern',
					contentType : "application/json; charset=UTF-8",
			    	type : 'delete',
			    	data : JSON.stringify(code),
			    	dataType : "",
			    	success: function(data, textStatus){
				          console.log(data, textStatus);
				        },
				        error: function(data, textStatus){
				         console.log(data.responseText, textStatus)
				         }
				});	 
			  }
			  else{
			    $(this).addClass('btn_unlike');
			    $(this).children('.ani_heart_m').addClass('hi');
			    $(this).children('.ani_heart_m').removeClass('bye');
			    	var code = {anum:$(this).val(), unum:${user.unum==null ? 0 : user.unum}}
			    $.ajax({
					url: '/web/product-api/product_concern',
					contentType : "application/json; charset=UTF-8",
			    	type : 'POST',
			    	dataType : "",
			    	data : JSON.stringify(code),
			    	success: function(data, textStatus){
				          console.log(data, textStatus);
				        },
				        error: function(data, textStatus){
				         console.log(data.responseText, textStatus)
				         }
				});	 
			  }
			});
			var userCode = {unum:${user.unum==null ? 0 : user.unum}}
		   $.ajax({
				url: '/web/product-api/concern_list',
				contentType : "application/json; charset=UTF-8",
		    	type : 'POST',
		    	dataType : 'json',
		    	data : JSON.stringify(userCode),
		    	success: function(data, textStatus){
			          console.log(data, textStatus);
			          for(var i of ${anum}){
			        	   /* 배열안에 anum값이 있으면 실행 */
			        	  if(data.includes(i)){
			        		$('.btn'+i).addClass('btn_unlike');
							$('.btn'+i).children('.ani_heart_m').addClass('hi');
			        	  }
			          }
			        },
			        error: function(data, textStatus){
			         console.log(data.responseText, textStatus)
			         }
			});	 
	})	

	for(let i=0; i<${productList.size()}; i++){
			console.log(${productList[i].anum})
		}
	
	
		function selChange() {
			var sel = document.getElementById('cntPerPage').value;
			location.href = "/web/aucts/index?value=${param.value}&key=${param.key}&nowPage=${paging.nowPage}&cntPerPage="
					+ sel;
		}

		var swiper = new Swiper(".mySwiper", {
			spaceBetween : 30, // 슬라이드 사이 여백

			slidesPerView : 'auto', // 한 슬라이드에 보여줄 갯수
			centeredSlides : true, //센터모드
			autoplay : { //자동슬라이드 (false-비활성화)
				delay : 3000, // 시간 설정
				disableOnInteraction : false, // false-스와이프 후 자동 재생
			},

			loop : false, // 슬라이드 반복 여부

			loopAdditionalSlides : 1,

			// 슬라이드 반복 시 마지막 슬라이드에서 다음 슬라이드가 보여지지 않는 현상 수정
			pagination : { // 호출(pager) 여부
				el : ".swiper-pagination", //버튼을 담을 태그 설정
				clickable : true, // 버튼 클릭 여부
			},
		});
	
	</script>
</body>
</html>