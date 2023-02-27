<%@page import="java.util.ArrayList"%>
<%@page import="com.myauct.web.domain.auctmaster.dto.AuctMasterDTO"%>
<%@page import="java.util.List"%>
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

	<main id="main">
		<!-- ======= Breadcrumbs ======= -->
		<div class="breadcrumbs">
			<div class="page-header d-flex align-items-center"
				style="background-image: url('/web/images/page-header.jpg');">
				<div class="container position-relative">
					<div class="row d-flex justify-content-center">
						<div class="col-lg-6 text-center">
							<h2>About</h2>
							<p>Odio et unde deleniti. Deserunt numquam exercitationem.
								Officiis quo odio sint voluptas consequatur ut a odio
								voluptatem. Sit dolorum debitis veritatis natus dolores. Quasi
								ratione sint. Sit quaerat ipsum dolorem.</p>
						</div>
					</div>
				</div>
			</div>
			<nav>
				<div class="container">
					<ol>
						<li><a href="index">Home</a></li>
						<li>About</li>
					</ol>
				</div>
			</nav>
		</div>
		<!-- End Breadcrumbs -->

		<!-- ======= About Us Section ======= -->
		<section id="about" class="about">
			<div class="container" data-aos="fade-up">

				<div class="row gy-4">
					<div
						class="col-lg-6 position-relative align-self-start order-lg-last order-first">
						<img src="/web/images/about.jpg" class="img-fluid" alt=""> <a
							href="https://www.youtube.com/watch?v=LXb3EKWsInQ"
							class="glightbox play-btn"></a>
					</div>
					<div class="col-lg-6 content order-last  order-lg-first">
						<h3>About Us</h3>
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

		<!-- ======= Stats Counter Section ======= -->
		<section id="stats-counter" class="stats-counter pt-0">
			<div class="container" data-aos="fade-up">

				<div class="row gy-4">

					<div class="col-lg-3 col-md-6">
						<div class="stats-item text-center w-100 h-100">
							<a href="about" style="color: white"> <span
								data-purecounter-start="0"
								data-purecounter-end="${cntMap.productCnt}"
								data-purecounter-duration="1" class="purecounter"></span>
							</a>
							<c:if test="${param.value==null}">
								<p>총 경매 수</p>
							</c:if>
							<c:if test="${param.value != null}">
								<p>${param.value}관련 경매 수</p>
							</c:if>
						</div>
					</div>
					<!-- End Stats Item -->

					<div class="col-lg-3 col-md-6">
						<c:if test="${user != nul}">
							<div class="stats-item text-center w-100 h-100">
								<a href="about?key=B" style="color: white"> <span
									data-purecounter-start="0"
									data-purecounter-end="${cntMap.concernCnt}"
									data-purecounter-duration="1" class="purecounter"></span>
								</a>
								<p>관심 목록</p>
							</div>
						</c:if>
					</div>
					<!-- End Stats Item -->

					<div class="col-lg-3 col-md-6">
						<c:if test="${user != nul}">
							<div class="stats-item text-center w-100 h-100">
								<a href="about?key=A" style="color: white"> <span
									data-purecounter-start="0"
									data-purecounter-end="${cntMap.userProductCnt}"
									data-purecounter-duration="1" class="purecounter"></span>
								</a>
								<p>나의 상품</p>
							</div>
						</c:if>
					</div>
					<!-- End Stats Item -->

					<div class="col-lg-3 col-md-6">
						<c:if test="${user != nul}">
							<div class="stats-item text-center w-100 h-100">
								<span data-purecounter-start="0"
									data-purecounter-end="${cntMap.userBoardCnt}"
									data-purecounter-duration="1" class="purecounter"></span>
								<p>내 상품 답글수</p>
							</div>
						</c:if>
					</div>
					<!-- End Stats Item -->

				</div>

			</div>
		</section>
		<!-- End Stats Counter Section -->

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
								<c:if test="${user!=null}">
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
									href="/web/aucts/about?nowPage=${paging.startPage - 1 }&cntPerPage=${paging.cntPerPage}&value=${param.value}&key=${param.key}"
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
											href="/web/aucts/about?nowPage=${p}&cntPerPage=${paging.cntPerPage}&value=${param.value}&key=${param.key}">${p}</a></li>
									</c:when>
								</c:choose>
							</c:forEach>
							<c:if test="${paging.endPage != paging.lastPage}">
								<li class="page-item"><a class="page-link"
									href="/web/aucts/about?nowPage=${paging.endPage+1}&cntPerPage=${paging.cntPerPage}&value=${param.value}&key=${param.key}">Next</a></li>
							</c:if>
						</ul>
					</nav>
				</div>
			</div>
		</section>
		<!-- End Services Section -->

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