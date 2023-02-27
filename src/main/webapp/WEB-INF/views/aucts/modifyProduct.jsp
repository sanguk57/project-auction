<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- ======= Head ======= -->
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<%
UserDTO dto = (UserDTO) session.getAttribute("user");
%>
<!DOCTYPE html>
<style>
.swiper {
	width: 100%;
	height: 100%;
}

.swiper-slide {
	text-align: center;
	font-size: 18px;
	background: #fff;
	/* Center slide text vertically */
	display: -webkit-box;
	display: -ms-flexbox;
	display: -webkit-flex;
	display: flex;
	-webkit-box-pack: center;
	-ms-flex-pack: center;
	-webkit-justify-content: center;
	justify-content: center;
	-webkit-box-align: center;
	-ms-flex-align: center;
	-webkit-align-items: center;
	align-items: center;
}

.swiper-slide img {
	display: block;
	width: 50rem;
	height: 28.125rem;
	object-fit: cover;
}

.swiper-button-next {
	background: url(/web/images/next.png) no-repeat;
	background-size: 100% auto;
	background-position: center;
}

.swiper-button-prev {
	background: url(/web/images/prev.png) no-repeat;
	background-size: 100% auto;
	background-position: center;
}

.swiper-button-next::after, .swiper-button-prev::after {
	display: none;
}

.fileuploder label {
	display: inline-block;
	padding: .5em .75em;
	font-size: inherit;
	line-height: normal;
	vertical-align: middle;
	background-color: #cae1f2;
	cursor: pointer;
	border: 1px solid #ebebeb;
	border-bottom-color: #e2e2e2;
	border-radius: .25em;
}

.fileuploder input[type="file"] {
	position: absolute;
	width: 1px;
	height: 1px;
	padding: 0;
	margin: -1px;
	overflow: hidden;
	clip: rect(0, 0, 0, 0);
	border: 0;
}
</style>

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
						<h2>경매 상품 등록</h2>
						<p>Odio et unde deleniti. Deserunt numquam exercitationem.
							Officiis quo odio sint voluptas consequatur ut a odio voluptatem.
							Sit dolorum debitis veritatis natus dolores. Quasi ratione sint.
							Sit quaerat ipsum dolorem.</p>
					</div>
				</div>
			</div>
		</div>
		<nav>
			<div class="container">
				<ol>
					<li><a href="index">Home</a></li>
					<li>Get a Quote</li>
				</ol>
			</div>
		</nav>
	</div>
	<!-- End Breadcrumbs -->
</main>

<!-- ======= Get a Quote Section ======= -->
<section id="get-a-quote" class="get-a-quote">
	<div class="container" data-aos="fade-up">
		<h2 class="text-center mb-2">${aDTO.anum}:${category}판매 상품 수정</h2>
		<h2 id="Eday-Time"></h2>
		<form action="/web/aucts/auctionItem" method="post" class="mt-3"
			enctype="multipart/form-data">
			<input type="hidden" name="unum" value="${user.unum}">
			<div class="row g-0">
				<!-- <div class="col-lg-5 quote-bg"
					style="background-image: url(/web/images/quote-bg.jpg);"></div> -->
				<div class="col-lg px-3">
					<div class="row gy-4">
						<div class="col-md-12 pt-3">
							<div class="form-floating">
								<input type="text" id="prod_title" name="prod_title"
									value="${aDTO.prod_title}" class="form-control"
									placeholder="title"> <label for="prod_title">게시글
									제목</label>
							</div>
						</div>
						
							<div class="col-md-4">
								<div class="form-floating">
									<input type="text" name="prod_name" id="prod_name"
										value="${aDTO.prod_name}" class="form-control form-control-sm"
										placeholder="상품 이름"> <label for="prod_name">상품명</label>
								</div>
							</div>

							<div class="col-md-4">
								<div class="input-group mb-3">
									<input type="text" class="form-control d-none" id="category"
										value="${category}" name="category" placeholder="카테고리"
										aria-label="category_chk" aria-describedby="category_chk">
									<select class="form-select" aria-label=".form-select example"
										id="cnum" name="cnum">
										<option disabled>카테고리</option>
									</select>
								</div>
							</div>
							<div class="col-md-4">
								<div class="form-floating">
									<input type="hidden" name="start_amt" id="start_amt"> <input
										type="text" name="start_amt_input" value="${aDTO.start_amt}"
										onchange="inputNumberFormat(this)" id="start_amt_input"
										class="form-control form-control-sm" placeholder="경매시작 가격"
										required> <label for="start_amt_input">경매시작 가격</label>
								</div>
							</div>

						<div class="col-md-3">
							<select class="form-select form-select-sm"
								aria-label=".form-select-sm example" id="prod_type"
								name="prod_type">
								<option disabled>중고 상품 유무 ${aDTO.prod_type} == Y</option>
								<c:choose>
									<c:when test="${aDTO.prod_type} == Y">
										<option selected="selected" value="Y">중고상품</option>
										<option value="N">새상품</option>
									</c:when>
									<c:otherwise>
										<option value="Y">중고상품</option>
										<option selected="selected" value="N">새상품</option>
									</c:otherwise>
								</c:choose>
							</select>
						</div>

						<div class="col-md-3">
							<select class="form-select form-select-sm"
								aria-label=".form-select-sm example" id="as_type" name="as_type">
								<option disabled>AS가능 여부 ${aDTO.as_type} == Y</option>
								<c:choose>
									<c:when test="${aDTO.as_type} == Y">
										<option selected="selected" value="Y">가능</option>
										<option value="N">불가능</option>
									</c:when>
									<c:otherwise>
										<option value="Y">가능</option>
										<option selected="selected" value="N">불가능</option>
									</c:otherwise>
								</c:choose>
							</select>
						</div>

						<div class="col-md-3">
							<select class="form-select form-select-sm"
								aria-label=".form-select-sm example" id="limit_type"
								name="limit_type">
								<option disabled>즉시구매 가능 여부 ${aDTO.limit_type} == Y</option>
								<c:choose>
									<c:when test="${aDTO.limit_type} == Y">
										<option selected="selected" value="Y">가능</option>
										<option value="N">불가능</option>
									</c:when>
									<c:otherwise>
										<option value="Y">가능</option>
										<option selected="selected" value="N">불가능</option>
									</c:otherwise>
								</c:choose>
							</select>
						</div>

						<input type="hidden" name="limit_amt" id="limit_amt">
							<div class="col-md-3 d-none" id="d-none">
								<div class="form-floating">
									<input type="text" name="limit_amt_input"
										value="${aDTO.limit_amt }" onchange="inputNumberFormat(this)"
										id="limit_amt_input" class="form-control form-control-sm"
										placeholder="경매시작 가격"> <label for="limit_amt_input">즉시구매
										가격</label>
								</div>
							</div>

							<div class="col-md-3">
								<input type="number" name="total_cnt" id="total_cnt"
									value="${aDTO.total_cnt}" placeholder="경매상품 수량"
									class="form-control form-control-sm">
							</div>

							<div class="col-md-3">
								<input type="hidden" name="join_amt" id="join_amt" value="0">
								<div class="form-floating">

									<input type="text" name="amt" id="amt" value="${aDTO.join_amt}"
										class="form-control form-control-sm" placeholder="입찰단위"
										onchange="inputNumberFormat(this)" required> <label
										for="amt">입찰 단위</label>
								</div>

								<select class="form-select form-select-sm"
									aria-label="form-select-sm example" id="amt_chk">
									<option selected disabled>입찰 단위</option>
									<option>100원</option>
									<option>500원</option>
									<option>1,000원</option>
									<option>5,000원</option>
									<option>10,000원</option>
									<option>50,000원</option>
									<option>직접입력</option>
								</select>
							</div>
						
						<div class="col-md-3">
							<div class="form-floating">
								<input type="hidden" name="curr_amt" id="curr_amt"> <input
									type="text" name="curr_amt_input" id="curr_amt_input"
									value="${aDTO.curr_amt}" class="form-control form-control-sm"
									placeholder="현재 상품 가격" onchange="inputNumberFormat(this)"
									required> <label for="curr_amt_input">현재 상품 가격</label>
							</div>
						</div>
						<!-- 셀렉트 값 설정 다시 해야함 -->
						<div class="col-md-3">
							<select class="form-select form-select-sm"
								aria-label=".form-select-sm example" id="trans_type"
								name="trans_type">
								<option disabled>거래 방식 ${aDTO.trans_type} == Y</option>
								<c:choose>
									<c:when test="${aDTO.trans_type} != Y">
										<option selected="selected" value="Y">택배거래</option>
										<option value="N">직거래</option>
									</c:when>
									<c:otherwise>
										<option value="Y">택배거래</option>
										<option selected="selected" value="N">직거래</option>
									</c:otherwise>
								</c:choose>
							</select>
						</div>

						<div class="col-md-6" id="date-time">
							<div class="col-md-3">
								<label for="exampleFormControlInput1" class="form-label">경매
									시작 날짜</label> <input type="text" name="auct_start"
									value="${aDTO.auct_start}" id="auct_start"
									class="form-control form-control-sm" placeholder="경매 시작 날짜"
									required>
							</div>
							<div class="col-md-3">
								<label for="exampleFormControlInput1" class="form-label">경매
									종료 날짜</label> <input type="text" name="auct_end" id="auct_end"
									value="${aDTO.auct_end}" class="form-control form-control-sm"
									placeholder="경매 종료 날짜" required>
							</div>

						</div>
						
						<div class="col-md-4">
							<div class="input-group mb-3">
								<input type="text" class="form-control" placeholder="판매가능 지역"
									name="sales_addr" id="roadFullAddr" value="${aDTO.sales_addr}"
									aria-label="Recipient's username"
									aria-describedby="button-addon2">
								<button class="btn btn-outline-secondary" type="button"
									id="button-addon2" onclick="javascript:goPopup();">주소검색</button>
							</div>
						</div>


						<div class="col-md-12 text-center">
							<h4>상품 상세 설명</h4>
						</div>

						<div class="col-md-12">
							<div class="form-floating">
								<textarea class="form-control"
									placeholder="Leave a comment here" name="contents"
									id="contents" style="height: 150px">${aDTO.contents}</textarea>
								<label for="contents">상세 설명</label>
							</div>
						</div>
						<div class="col-md-12 fileuploder">
							<label for="ex_file">파일 등록</label> <input type='file'
								onchange="imageChange(event)" id='ex_file' multiple='multiple'
								class="btn-file" accept="image/jpeg,.png" name="uploadFile" />
						</div>

						<div class="col-md-12">
							<div class="swiper mySwiper">
								<div class="swiper-wrapper"></div>
								<div class="swiper-button-next"></div>
								<div class="swiper-button-prev"></div>
								<div class="swiper-pagination"></div>
							</div>
						</div>

						<div class="col-md-6">
							<button id="modifyBtn"
								class="btn btn-outline-secondary mt-3 w-100">수정</button>
						</div>
						<div class="col-md-6">
							<a href="productView?anum=${aDTO.anum}"
								class="btn btn-outline-secondary mt-3 w-100">취소</a>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<!-- End Quote Form -->


</section>
<!-- End Get a Quote Section -->

</main>
<!-- End #main -->

<!-- ======= Footer ======= -->
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
<!-- End Footer -->
<script type="text/javascript" defer="defer">
$(function(){
	
	jQuery.datetimepicker.setLocale('kr');
	$("#auct_start").datetimepicker({
	    changeMonth: true,
	    changeYear: true,
	    showButtonPanel: true,
	    format:'Y-m-d H:i',
	    step: 30,
	    minDate: 0,
	    minTime: 0,
	    defaultSelect: false,
	    defaultDate: false,
	    onClose: function(ct, $i) {
	        let endDateInput = $("#auct_end");
	        if($("#auct_end").val() != ''){
	            let tempStartDate = new Date(ct);
	            let tempEndDate = new Date(endDateInput.val());
	            if(tempStartDate > tempEndDate){
	                endDateInput.val(getFormatDateTime(ct));
	            }
	        }else {
	            /* endDateInput.val(getFormatDateTime(ct)); */
	        }
	    },
	    onSelectDate: function(ct, $i){
	        $("#auct_end").datetimepicker('setOptions', { minDate: ct });
	    },
	    onSelectTime: function(ct, $i){
	        $("#auct_end").datetimepicker('setOptions', { minDate: ct });
	    },
	});
	
	$("#auct_end").datetimepicker({
	    changeMonth: true,
	    changeYear: true,
	    showButtonPanel: true,
	    format:'Y-m-d H:i',
	    step: 30,
	    minDate: 0,
	    defaultSelect: false,
	    defaultDate: false,
	    onClose: function(ct, $i) {
	        let startDateInput = $("#auct_start");
	        if($("#auct_start").val() != ''){
	            let tempStartDate = new Date(startDateInput.val());
	            let tempEndDate = new Date(ct);
	            if(tempStartDate > tempEndDate){
	                startDateInput.val(getFormatDateTime(ct));
	            }
	        }else {
	            /* startDateInput.val(getFormatDateTime(ct)); */
	        }
	    },
	    onSelectDate:function( ct, $i ){
	        $("#auct_start").datetimepicker('setOptions', { maxDate: ct });
	        $("#auct_start").datetimepicker('setOptions', { maxTime: ct });
	       
	    },
	    onSelectTime:function( ct, $i ){
	        $("#auct_start").datetimepicker('setOptions', { maxDate: ct });
	        $("#auct_start").datetimepicker('setOptions', { maxTime: ct });
	       
	    },
	});
	 
	 $.ajax({
	        url: "/web/product-api/product_category",
	        type: "POST",
	        contentType : "application/json; charset=UTF-8",
	        dataType : "json",
	      	success: function(data, textStatus){
	          console.log(data, textStatus);
	          for(var value in data){
	        	  console.log('${aDTO.cnum}', value)
	        	  if('${aDTO.cnum}' == value){
	        	 $('#cnum').append("<option selected value='"+value+"'  >"+data[value]+"</option>")
	        	  }else{
	        	 $('#cnum').append("<option value='"+value+"'  >"+data[value]+"</option>")
	        	  }
	          }
	          $('#cnum').append("<option value='0'>직접입력</option>")
	        },
	        error: function(data, textStatus){
	         console.log(data.responseText, textStatus)
	         }
	      });
	 
		});
		

const countDownTimer1 = function (id, date) {
	var _vDate = new Date(date); // 전달 받은 일자
	var _second = 1000;
	var _minute = _second * 60;
	var _hour = _minute * 60;
	var _day = _hour * 24;
	var timer;

	function showRemaining1() {
		var now = new Date();
		var distDt = _vDate - now;
		
		if (distDt <= 0) {
			clearInterval(timer);
			document.getElementById(id).textContent = '경매가 시작 됩니다. ';
			document.getElementById('date-time').style.display = 'none';
			return;
			
		}
			var days = Math.floor(distDt / _day);
			var hours = Math.floor((distDt % _day) / _hour);
			var minutes = Math.floor((distDt % _hour) / _minute);
			var seconds = Math.floor((distDt % _minute) / _second);

			//document.getElementById(id).textContent = date.toLocaleString() + "까지 : ";
			document.getElementById(id).textContent = '경매시작 까지 남은 시간 : ';
			document.getElementById(id).textContent += days + '일 ';
			document.getElementById(id).textContent += hours + '시간 ';
			document.getElementById(id).textContent += minutes + '분 ';
			document.getElementById(id).textContent += seconds + '초';
		}
timer = setInterval(showRemaining1, 1000)
	}
	
const countDownTimer2= function (id, date) {
	var _eDate = new Date(date); // 전달 받은 일자
	var _second = 1000;
	var _minute = _second * 60;
	var _hour = _minute * 60;
	var _day = _hour * 24;
	var timer;
	
	function showRemaining2() {
		var now = new Date();
		var distEt = _eDate - now;
		if (distEt <= 0) {
			clearInterval(timer);
			document.getElementById(id).textContent = '경매가 마감 되었습니다.';
			return;
		}
		var days = Math.floor(distEt / _day);
		var hours = Math.floor((distEt % _day) / _hour);
		var minutes = Math.floor((distEt % _hour) / _minute);
		var seconds = Math.floor((distEt % _minute) / _second);

		//document.getElementById(id).textContent = date.toLocaleString() + "까지 : ";
		document.getElementById(id).textContent = '경매마감 까지 남은 시간 : ';
		document.getElementById(id).textContent += days + '일 ';
		document.getElementById(id).textContent += hours + '시간 ';
		document.getElementById(id).textContent += minutes + '분 ';
		document.getElementById(id).textContent += seconds + '초';
	}
	timer = setInterval(showRemaining2, 1000)
}

countDownTimer1('Eday-Time', '${aDTO.auct_start}');
countDownTimer2('Eday-Time', '${aDTO.auct_end}');


var swiper = new Swiper(".mySwiper", {
    spaceBetween: 30,    // 슬라이드 사이 여백

    slidesPerView : 'auto', // 한 슬라이드에 보여줄 갯수
    centeredSlides: true,    //센터모드
    autoplay: {     //자동슬라이드 (false-비활성화)
      delay: 2500, // 시간 설정
      disableOnInteraction: false, // false-스와이프 후 자동 재생
    },

    loop : false,   // 슬라이드 반복 여부

    loopAdditionalSlides : 1,

// 슬라이드 반복 시 마지막 슬라이드에서 다음 슬라이드가 보여지지 않는 현상 수정
    pagination: { // 호출(pager) 여부
      el: ".swiper-pagination", //버튼을 담을 태그 설정
      clickable: true, // 버튼 클릭 여부
    },
    navigation: {   // 버튼
      nextEl: ".swiper-button-next",
      prevEl: ".swiper-button-prev",
    },
  });
  
function imageChange(event){
	document.querySelector(".swiper-wrapper").innerHTML = "";
    let i = event.target.files.length-1;
    for(let image of event.target.files){
	if(!fileCheck(image.size, image.name)){
		/* 이미지 파일이 조건에 않맞을때 없어야 함 */
		return
	}else{
    	document.querySelector(".swiper-wrapper").innerHTML += `<div class="swiper-slide"><img class="images" /></div>`		
	}
    }
    	const img = document.querySelectorAll(".images")
    	img.forEach((e)=>{
        const reader = new FileReader();
        reader.onload = function(event){
            e.setAttribute("src", event.target.result);
        }
        reader.readAsDataURL(event.target.files[i--]);  
        /* document.querySelector("#imageContainer").appendChild(img); */
    	})
}

	function fileCheck(fileSize, fileName) {
		let maxSize = 3145728; //3MB = 1024*1024*3	
		if (fileSize >= maxSize) {
			alert("파일 사이즈 초과");
			return false;
		}
		if(fileName.length > 30)
			{
			alert("파일이 길이가 초과");
			}
		return true;
	}

	function goPopup() {
		var pop = window
				.open(
						"/web/aucts/jusoPopup",
						"pop",
						"width = 580, height = 300, top = 100, left = 450, scrollbars=yes, resizable=yes");
	}

	function jusoCallBack(roadFullAddr) {
		// 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.
		document.getElementById('roadFullAddr').value = roadFullAddr;
	}

	function inputNumberFormat(obj) {
		if (obj.value != '') {
			obj.value = comma(uncomma(obj.value));
			document.querySelector("#join_amt").value = document
					.querySelector("#amt").value.replace(/,|원/g, '')
			document.querySelector("#curr_amt").value = document
					.querySelector("#curr_amt_input").value.replace(/,|원/g, '')
			document.querySelector("#limit_amt").value = document
					.querySelector("#limit_amt_input").value
					.replace(/,|원/g, '')
			document.querySelector("#start_amt").value = document
					.querySelector("#start_amt_input").value
					.replace(/,|원/g, '')
		}

	}
console.log(${aDTO.cnum})
	function comma(str) {
		str = String(str);
		str = str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, "$1,");
		if (str != '') {
			str += "원"
		}
		return str
	}

	function uncomma(str) {
		str = String(str);
		return str.replace(/[^\d]+/g, "");
	}

	const amt = document.querySelector("#amt");
	const amt_chk = document.querySelector("#amt_chk");

	amt_chk.addEventListener("change", function() {
		if (amt_chk.value == "직접입력") {
			amt.value = "";
		} else {
			amt.value = amt_chk.value;
			document.querySelector("#join_amt").value = document
					.querySelector("#amt").value.replace(/,|원/g, '');
			console.log(document.querySelector("#join_amt").value)
		}
	});

	const total_cnt = document.querySelector("#total_cnt");
	total_cnt.addEventListener("change", function() {
		if (total_cnt.value <= 0) {
			alert("최소수량 1")
			total_cnt.value = 1;
		}
	});

	const limit_type = document.querySelector("#limit_type");
	limit_type.addEventListener("change", function() {
		if (limit_type.value == 'Y') {
			document.querySelector("#d-none").classList.remove('d-none');
		} else {
			document.querySelector("#d-none").classList.add('d-none');

			document.querySelector("#limit_amt").value = "0";
		}
	});

	const cnum = document.querySelector("#cnum");
	cnum.addEventListener("change", function() {
		if(cnum.value == '0'){
			document.querySelector("#category").classList.remove('d-none');
		} else {
			document.querySelector("#category").classList.add('d-none');
		}
	});

	document.querySelector("#join_amt").value = document.querySelector("#amt").value
	console.log(document.querySelector("#join_amt").value)
</script>

</html>