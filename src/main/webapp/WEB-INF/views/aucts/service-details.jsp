<%@page import="com.myauct.web.domain.user.dto.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!DOCTYPE html>
<style>
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
						<h2>${auctMasterDTO.prod_title}</h2>
						<p>${auctMasterDTO.contents}</p>
					</div>
				</div>
			</div>
		</div>
		<nav>
			<div class="container">
				<ol>
					<li><a href="index">Home</a></li>
					<li>Service Details</li>
				</ol>
			</div>
		</nav>
	</div>
	<!-- End Breadcrumbs -->

	<!-- ======= Service Details Section ======= -->
	<section id="service-details" class="service-details">
		<div class="container" data-aos="fade-up">

			<div class="row gy-4">
				<h3 class="text-center">${auctMasterDTO.anum}:${category}:
					${auctMasterDTO.prod_name}</h3>
				<div class="col-lg-5">
					<div class="card-img card${product.anum} swiper mySwiper">
						<div class="swiper-wrapper">
							<c:forEach var="images" items="${uploadFileList}">
								<div class="swiper-slide">
									<img src="/web/upload/${images}" alt=""
										class="img-fluid services-img">
								</div>
							</c:forEach>
						</div>
						<div class="swiper-button-next"></div>
						<div class="swiper-button-prev"></div>
						<div class="swiper-pagination"></div>
					</div>
				</div>
				<div class="col-lg-7">
					<ul>
						<li><i class="bi bi-check-circle"></i><span>?????? : <c:if
									test="${auctMasterDTO.prod_type == N}">
								?????????
								</c:if> ??????
						</span></li>
						<li><i class="bi bi-check-circle"></i><span>AS : <c:if
									test="${auctMasterDTO.as_type == N}">
								????????? 
								</c:if> ??????
						</span></li>
						<li><i class="bi bi-check-circle"></i><span>???????????? : <c:if
									test="${auctMasterDTO.limit_type == N}">
									????????? 
									</c:if> ??????
						</span></li>
						<li><i class="bi bi-check-circle"></i><span>???????????? :<c:if
									test="${auctMasterDTO.trans_type == N}">
									????????? 
									</c:if> ??????
						</span></li>
					</ul>

					<div class="row gy-4">
						<div class="col-lg-6">
							<h4>????????? ???</h4>
							<p>${auctMasterDTO.join_cnt}???</p>
						</div>
						<div class="col-lg-6">
							<h4>?????? ?????????</h4>
							<fmt:formatNumber value="${auctMasterDTO.start_amt}"
								pattern="#,###???" />
						</div>
						<div class="col-lg-6">
							<h4>????????????</h4>
							<p>${auctMasterDTO.sales_addr}</p>
						</div>
						<div class="col-lg-6">
							<h4>????????? ???????????? ??????</h4>
							<p>
								<fmt:formatNumber value="${auctMasterDTO.curr_amt}"
									pattern="#,###???" />
							</p>
						</div>
					</div>
					<div class="services-list">
						<div>
							<span id="countDown"></span>
							<c:if test="${user.unum == auctMasterDTO.unum}">
								<a class="btn btn-outline-primary"
									href="modifyProduct?anum=${auctMasterDTO.anum}" id="modifyBtn">??????
									??????</a>
								<a class="btn btn-outline-primary"
									href="deleteProduct?anum=${anucMasterDTO.anum}" id="deleteBtn">??????</a>
							</c:if>
						</div>
						<c:choose>
							<c:when test="${user == null}">
								<div>
									<p class="alert alert-primary " role="alert">
										???????????? ?????? :
										<fmt:formatNumber value="${auctMasterDTO.limit_amt}"
											pattern="#,###???" />
										<a class="btn btn-outline-primary" href="/web/users/login">????????????</a>
								</div>
							</c:when>
							<c:otherwise>
								<div>
									<select class="form-select form-select-sm"
										aria-label=".form-select-sm example" id="amount" name="amount">
										<option selected="selected" disabled>?????? ??????</option>
									</select>
								</div>
								<c:if
									test="${auctMasterDTO.limit_amt > (auctMasterDTO.start_amt+auctMasterDTO.join_amt)}">
									<div class="input-group mb-3">
										<form action="">
											<p class="input-group">
												<input type="text" class="form-control reStart_amt w-75"
													onchange="inputNumberFormat(this)" placeholder="????????? ??????"
													aria-label="Recipient's username"
													aria-describedby="button-addon2">
												<button class="btn btn-outline-primary btn-sm w-25"
													type="button" id="button-addon1">?????? ??????</button>
											</p>
											<input type="hidden" id="start_amt" />
										</form>
									</div>

									<div class="input-group mb-3" id="dp">
										<form>
											<p class="input-group">
												<input type="text" class="form-control w-75" disabled
													value="<fmt:formatNumber value="${auctMasterDTO.start_amt+auctMasterDTO.join_amt}"  pattern="#,###???"/>"
													aria-label="Recipient's username" id="product_amt"
													aria-describedby="button-addon2" name="start_amt">
												<button class="btn btn-outline-primary btn-sm w-25"
													type="button" id="button-addon2">?????? ?????? ??????</button>
											</p>
										</form>
									</div>
								</c:if>
								<div>
									<p class="alert alert-primary " role="alert" id="reStart_amt">
										????????? ?????? :
										<fmt:formatNumber
											value="${auctMasterDTO.start_amt+auctMasterDTO.join_amt}"
											pattern="#,###???" />
									</p>
								</div>
								<c:if test="${auctMasterDTO.limit_type != N}">
									<div>
										<p class="alert alert-primary " role="alert">
											???????????? ?????? :
											<fmt:formatNumber value="${auctMasterDTO.limit_amt}"
												pattern="#,###???" />
											<button class="btn btn-outline-primary" type="button"
												id="limit_btn">????????????</button>
										</p>
									</div>
								</c:if>
								
								<c:if test="${user != null}">
									<div>
										<form>
											<input type="hidden" value="${auctMasterDTO.anum}">
											<p class="input-group" id="board-group">
												<input id="subject" type="text" aria-label="First-title"
													class="form-control" style="width: 15%"> <input
													type="text" aria-label="contents" class="form-control"
													style="width: 50%" id="contents">
												<button class="btn btn-outline-primary btn-sm"
													style="width: 15%" type="button" id="board-cancel">??????</button>
												<button class="btn btn-outline-primary btn-sm"
													style="width: 20%" type="button" id="boardCreate">??????
													??????...</button>
											</p>
										</form>
									</div>
								</c:if>
							</c:otherwise>
						</c:choose>
						<c:forEach var="board" items="${boardList}" varStatus="status">
							<div class="board-list look">
								<p>${nameList[status.index]} : ${board.wdate}</p>
								<p class="contents">${board.subject} : ${board.contents}</p>
								<input type="hidden" class="btnQnum" value="${board.qnum}">
								<button class="btn btn-outline-primary btn-sm board-memo">??????</button>
								<a class="memo_btn" href="#"><c:if test="${memoCntList[status.index] != 0 }">?????? ${memoCntList[status.index]}???</c:if> </a>
									<div id="memoList" class="memoList p-0 ps-3"></div>
									
									<form class=" memo mt-2">
									<p class="input-group" id="board-group">
									<input type="hidden" class="memo-qnum" value="${board.qnum}">
										<input type="text" aria-label="memo" class="form-control memo-text"
											style="width: 70%">
											<button class="btn btn-outline-primary btn-sm memo-cancel"
													style="width: 15%" type="button">??????</button>
										<button class="btn btn-outline-primary btn-sm memoCreate"
											style="width: 15%" type="button">
											??????</button>
									</p>
								</form>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- End Service Details Section -->

</main>
<!-- End #main -->

<!-- ======= Footer ======= -->
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
<!-- End Footer -->
<script type="text/javascript" defer="defer">
	$(function(){
		for(var i=1; i<=${auctMasterDTO.total_cnt}; i++){
			$('#amount').append("<option value='"+i+"'  >"+i+"</option>")
		}
		$('.memo_btn').click(function(e){
			e.preventDefault();
			e.stopPropagation();
			console.log($(e.currentTarget).siblings('.memoList').css("display") == 'none')
			if($(e.currentTarget).siblings('.memoList').css("display") == 'none') {
				$(e.currentTarget).siblings('.memoList').html(" ")
				$(e.currentTarget).siblings('.memoList').css("display", "block");
			}else{
				$(e.currentTarget).siblings('.memoList').css("display", "none");
			}
			let qnum = $(e.currentTarget).siblings('.btnQnum').val()
			console.log(qnum)
			var memoList = {qnum:Number(qnum)}
			 $.ajax({
			        url: "/web/product-api/memoList",
			        type: "POST",
			        contentType : "application/json; charset=UTF-8",
			        dataType : "json",
			        data : JSON.stringify(memoList),
			      	success: function(data, textStatus){
			          for(var i in data){
			        	  $(e.currentTarget).siblings('#memoList').append("<p>"+data[i].wdate +" : "+ data[i].memo+"</p>")
			          }       
			        },
			        error: function(data, textStatus){
			         console.log(data.responseText, textStatus)
			         }
			      });
		})
		$('.memoCreate').click(function(e){
			e.stopPropagation();
			let qnum = $(e.currentTarget).siblings('.memo-qnum').val()
			let unum = ${user.unum == null ? '0' : user.unum}
			let text = $(e.currentTarget).siblings('.memo-text').val()
			
			 var memo = {qnum:Number(qnum), memo:text, unum:unum}
		  $.ajax({
		        url: "/web/product-api/create_memo",
		        type: "POST",
		        contentType : "application/json; charset=UTF-8",
		        dataType : "text",
		        data : JSON.stringify(memo),
		      	success: function(data, textStatus){
		          /* window.location.reload()		 */         
		        },
		        error: function(data, textStatus){
		         console.log(data.responseText, textStatus)
		         }
		      });
		})
		
		$('#boardCreate').click(function(e){
			var board = {anum:${auctMasterDTO.anum}, unum:${user.unum == null ? '0' : user.unum}, subject:$('#subject').val(), contents:$('#contents').val()}
		 $.ajax({
		        url: "/web/product-api/create_board",
		        type: "POST",
		        contentType : "application/json; charset=UTF-8",
		        dataType : "text",
		        data : JSON.stringify(board),
		      	success: function(data, textStatus){
		          window.location.reload()		         
		        },
		        error: function(data, textStatus){
		         console.log(data.responseText, textStatus)
		         }
		      });
			})
			
		$('#button-addon1').click(function(e){
			e.preventDefault();
			var product_amt = {start_amt:$('#start_amt').val(), anum:${auctMasterDTO.anum}, unum:${user.unum ==null ? "?????????" : user.unum}, volume:$('#start_amt').val(), amount:$('#amount').val()}
		 $.ajax({
		        url: "/web/product-api/product_auction",
		        type: "PUT",
		        contentType : "application/json; charset=UTF-8",
		        dataType : "text",
		        data : JSON.stringify(product_amt),
		      	success: function(data, textStatus){
		      		 window.location.reload()		     
		        },
		        error: function(data, textStatus){
		         console.log(data.responseText, textStatus)
		         }
		      });
			})
			
		$('#button-addon2').click(function(e){
			e.preventDefault();
			var product_amt = {start_amt:${auctMasterDTO.start_amt+auctMasterDTO.join_amt}, anum:${auctMasterDTO.anum}, unum:${user.unum ==null ? "?????????" : user.unum}, volume:${auctMasterDTO.start_amt+auctMasterDTO.join_amt}, amount:$('#amount').val()}
		 $.ajax({
		        url: "/web/product-api/product_auction",
		        type: "PUT",
		        contentType : "application/json; charset=UTF-8",
		        dataType : "text",
		        data : JSON.stringify(product_amt),
		      	success: function(data, textStatus){
		          window.location.reload()
		        },
		        error: function(data, textStatus){
		         console.log(data.responseText, textStatus)
		         }
		      });
			})
			/* ???????????? ?????? ???????????? ???????????? ????????? ?????????, ????????? ?????? ???????????? ui??? ???????????? ???  */
/* 		$('#limit_btn').click(function(e)){
			e.preventDefault();
			var limit_amt = 
		}	 */
		
	 	$('.memo').css("display", "none");
		$('.contents').css("display", "none");
		$('.memoList').css("display", "none");
		
		$('#board-cancel').click(function (){
			$('#contents').val('')
			$('#subject').val('')
		})
		
			$('.look').click(function(e){
				if($(e.currentTarget).children('.contents').css("display") == 'none')??{
				$(e.currentTarget).children('.contents').css("display", "block");
				}else{
				$(e.currentTarget).children('.contents').css("display", "none");
				}
			})
		  });
	
		$('.board-memo').click(function(e){
			e.stopPropagation();
			
			console.log("click")
			if($(e.currentTarget).siblings('.memo').css("display") == 'none') {
				$(e.currentTarget).siblings('.memo').css("display", "block");
				/* ?????? ????????? ????????? ????????? ?????? */
				$(e.currentTarget).siblings('.memo').siblings('.memo-text').focus()
			}else{
				$(e.currentTarget).siblings('.memo').css("display", "none");
			}
			
		})
		
		$('.memo-cancel').click(function(e){
			e.stopPropagation();
			console.log("click")
			$(e.currentTarget).closest('.memo').css("display", "none");
		})
		
	const countDownTimer1 = function (id, date) {
		var _vDate = new Date(date); // ?????? ?????? ??????
		var _second = 1000;
		var _minute = _second * 60;
		var _hour = _minute * 60;
		var _day = _hour * 24;
		var timer;

		function showRemaining1() {
			var now = new Date();
			var distDt = _vDate - now;
			
			if (distDt < 0) {
				clearInterval(timer);
				document.getElementById(id).textContent = '????????? ?????? ?????????. ';
				return;
				
			}
				var days = Math.floor(distDt / _day);
				var hours = Math.floor((distDt % _day) / _hour);
				var minutes = Math.floor((distDt % _hour) / _minute);
				var seconds = Math.floor((distDt % _minute) / _second);

				//document.getElementById(id).textContent = date.toLocaleString() + "?????? : ";
				document.getElementById(id).textContent = '???????????? ?????? ?????? ?????? : ';
				document.getElementById(id).textContent += days + '??? ';
				document.getElementById(id).textContent += hours + '?????? ';
				document.getElementById(id).textContent += minutes + '??? ';
				document.getElementById(id).textContent += seconds + '???';
			}
	timer = setInterval(showRemaining1, 1000)
		}
	
	
	const countDownTimer2 = function (id, date) {
		var _eDate = new Date(date); // ?????? ?????? ??????
		var _second = 1000;
		var _minute = _second * 60;
		var _hour = _minute * 60;
		var _day = _hour * 24;
		var timer;
		
		function showRemaining2() {
			var now = new Date();
			var distEt = _eDate - now;
			
			if (distEt < 0) {
				clearInterval(timer);
				document.getElementById(id).textContent = '????????? ?????? ???????????????.';
				document.getElementById(service-details).disabled = true;
				return;
			}
			var days = Math.floor(distEt / _day);
			var hours = Math.floor((distEt % _day) / _hour);
			var minutes = Math.floor((distEt % _hour) / _minute);
			var seconds = Math.floor((distEt % _minute) / _second);

			//document.getElementById(id).textContent = date.toLocaleString() + "?????? : ";
			document.getElementById(id).textContent = '???????????? ?????? ?????? ?????? : ';
			document.getElementById(id).textContent += days + '??? ';
			document.getElementById(id).textContent += hours + '?????? ';
			document.getElementById(id).textContent += minutes + '??? ';
			document.getElementById(id).textContent += seconds + '???';
		}
		timer = setInterval(showRemaining2, 1000)
	}
	
	countDownTimer1('countDown', "${auctMasterDTO.auct_start}")
	countDownTimer2('countDown', "${auctMasterDTO.auct_end}");
	
	document.getElementById('amount').addEventListener('change', ()=>{
	console.log()
	if(document.getElementById('amount').value != ''){
		document.getElementById('button-addon1').disabled = false
		document.getElementById('button-addon2').disabled = false
		document.getElementById('limit_btn').disabled = false
	} 
	
	});
	
	if(document.getElementById('amount').value == '?????? ??????'){
		document.getElementById('button-addon1').disabled = true
		document.getElementById('button-addon2').disabled = true
		document.getElementById('limit_btn').disabled = true
	} 
	
	if(document.getElementById('subject').value == '' || document.getElementById('contents').value == ''){
		document.getElementById('boardCreate').disabled = true
	}
	
	document.getElementById('subject').addEventListener('keyup', ()=>{
		if(document.getElementById('subject').value == '' || document.getElementById('contents').value == ''){
			document.getElementById('boardCreate').disabled = true
		}else{
			document.getElementById('boardCreate').disabled = false
		}
	})
	
	document.getElementById('contents').addEventListener('keyup', ()=>{
		if(document.getElementById('subject').value == '' || document.getElementById('contents').value == ''){
			document.getElementById('boardCreate').disabled = true
		}else{
			document.getElementById('boardCreate').disabled = false
		}
	})
	
	function inputNumberFormat(obj) {
		if (obj.value != '') {
			if(obj.value > ${auctMasterDTO.start_amt+auctMasterDTO.join_amt} && obj.value < ${auctMasterDTO.limit_amt})
				{
			document.querySelector('#start_amt').value = obj.value
			obj.value = comma(uncomma(obj.value));
			document.querySelector('#reStart_amt').innerText = "????????? ?????? : "+ obj.value
			document.querySelector('#dp').style.display = "none";
				}
			else{				
			obj.value = ''
			document.querySelector('#reStart_amt').innerText = "????????? ?????? : "+ document.querySelector('#product_amt').value
			document.querySelector('#dp').style.display = "block";
			}
		}
	}
	
	document.querySelector('.reStart_amt').addEventListener('keyup', ()=>{
			if(	document.querySelector('.reStart_amt').value == ''){
				document.querySelector('#dp').style.display = "block";
			} 
		})
	
	function comma(str) {
		str = String(str);
		str = str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, "$1,");
		if (str != '') {
			str += "???"
		}
		return str
	}

	function uncomma(str) {
		str = String(str);
		return str.replace(/[^\d]+/g, "");
	}
	
		var swiper = new Swiper(".mySwiper", {
			spaceBetween : 30, // ???????????? ?????? ??????

			slidesPerView : 'auto', // ??? ??????????????? ????????? ??????
			centeredSlides : true, //????????????
			autoplay : { //?????????????????? (false-????????????)
				delay : 3000, // ?????? ??????
				disableOnInteraction : false, // false-???????????? ??? ?????? ??????
			},

			loop : false, // ???????????? ?????? ??????

			loopAdditionalSlides : 1,

			// ???????????? ?????? ??? ????????? ?????????????????? ?????? ??????????????? ???????????? ?????? ?????? ??????
			pagination : { // ??????(pager) ??????
				el : ".swiper-pagination", //????????? ?????? ?????? ??????
				clickable : true, // ?????? ?????? ??????
			},
			navigation : { // ??????
				nextEl : ".swiper-button-next",
				prevEl : ".swiper-button-prev",
			},
		});
	</script>
</html>