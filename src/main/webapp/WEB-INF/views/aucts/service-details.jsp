<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!DOCTYPE html>
<body>
<%@ include file="/WEB-INF/views/include/header.jsp"%>
<c:set var="p" value="${auctMasterDTO}" />
<c:set var="status" value="${p.auct_status}" />
<c:set var="isOwner" value="${user != null && user.unum == p.unum}" />

<main id="main">
	<section class="ma-detail" style="padding-top: 110px">
		<div class="container">

			<nav aria-label="breadcrumb" class="mb-3">
				<ol class="breadcrumb small mb-0">
					<li class="breadcrumb-item"><a href="/web/aucts/index">홈</a></li>
					<li class="breadcrumb-item"><a href="/web/aucts/about?value=${fn:escapeXml(category)}"><c:out value="${category}" /></a></li>
					<li class="breadcrumb-item active" aria-current="page"><c:out value="${p.prod_name}" /></li>
				</ol>
			</nav>

			<div class="row g-4">
				<!-- ===== 사진 ===== -->
				<div class="col-lg-6">
					<div class="ma-card ma-gallery">
						<c:choose>
							<c:when test="${not empty uploadFileList}">
								<div class="swiper detailSwiper">
									<div class="swiper-wrapper">
										<c:forEach var="img" items="${uploadFileList}">
											<div class="swiper-slide"><img src="/web/upload/${fn:escapeXml(img)}" alt="<c:out value='${p.prod_name}' /> 사진"></div>
										</c:forEach>
									</div>
									<c:if test="${fn:length(uploadFileList) > 1}">
										<div class="swiper-button-next"></div>
										<div class="swiper-button-prev"></div>
										<div class="swiper-pagination"></div>
									</c:if>
								</div>
							</c:when>
							<c:otherwise>
								<div class="auct-thumb-empty"><i class="bi bi-image"></i>등록된 사진이 없습니다</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<!-- ===== 가격 · 입찰 ===== -->
				<div class="col-lg-6">
					<div class="ma-card ma-info">
						<span class="cat"><c:out value="${category}" /></span>
						<%-- 제목/설명은 c:out 으로 출력 (스크립트 삽입 방지) --%>
						<h1><c:out value="${p.prod_title}" /></h1>

						<div class="ma-chips">
							<span class="ma-chip"><i class="bi bi-box"></i>${p.prod_type == 'N' ? '새상품' : '중고'}</span>
							<span class="ma-chip"><i class="bi bi-tools"></i>AS ${p.as_type == 'N' ? '불가' : '가능'}</span>
							<span class="ma-chip"><i class="bi bi-truck"></i>${p.trans_type == 'N' ? '직거래' : '택배'}</span>
							<c:if test="${not empty p.sales_addr}">
								<span class="ma-chip"><i class="bi bi-geo-alt"></i><c:out value="${p.sales_addr}" /></span>
							</c:if>
						</div>

						<%-- 마감 처리된 경매: 결과 --%>
						<c:if test="${p.closed}">
							<div class="ma-result ${p.end_chk == 'U' ? 'unsold' : ''}">
								<c:choose>
									<c:when test="${p.end_chk == 'U'}">
										<i class="bi bi-x-circle"></i>
										<div><b>유찰</b><span>입찰 없이 경매가 끝났습니다.</span></div>
									</c:when>
									<c:otherwise>
										<i class="bi bi-trophy"></i>
										<div>
											<b>${p.end_chk == 'B' ? '즉시구매 완료' : '낙찰'} · <fmt:formatNumber value="${p.win_amt}" pattern="#,###" />원</b>
											<span>${user != null && user.unum == p.win_unum ? '축하합니다! 내가 낙찰받았습니다.' : '낙찰자 '}<c:if test="${!(user != null && user.unum == p.win_unum)}"><c:out value="${p.win_name_masked}" />님</c:if></span>
										</div>
									</c:otherwise>
								</c:choose>
							</div>
							<c:if test="${not empty counterpart}">
								<div class="ma-contact">
									<div class="t">${user.unum == p.unum ? '낙찰자' : '판매자'} 연락처 <small>거래를 위해 판매자와 낙찰자에게만 보입니다</small></div>
									<div><i class="bi bi-person"></i><c:out value="${counterpart.name}" /></div>
									<div><i class="bi bi-telephone"></i><a href="tel:${fn:escapeXml(counterpart.phone)}"><c:out value="${counterpart.phone}" /></a></div>
									<c:if test="${not empty counterpart.email}">
										<div><i class="bi bi-envelope"></i><c:out value="${counterpart.email}" /></div>
									</c:if>
								</div>
							</c:if>
						</c:if>

						<div id="countDown" class="ma-countdown ${status == 'READY' ? 'ready' : (status == 'ENDED' ? 'ended' : '')}" ${p.closed ? 'hidden' : ''}>
							<i class="bi ${status == 'ENDED' ? 'bi-flag' : 'bi-clock-history'}"></i>
							<span class="text"><c:out value="${p.time_label}" /></span>
						</div>

						<div class="ma-price-box">
							<div class="label">${p.closed && p.end_chk != 'U' ? '낙찰가' : '현재가'} <span class="ma-live" id="liveBadge" hidden><i></i>실시간</span></div>
							<div class="now" id="priceNow"><fmt:formatNumber value="${p.start_amt}" pattern="#,###" />원</div>
							<div class="sub">
								<div>입찰<strong id="bidCount">${p.join_cnt}회</strong></div>
								<div>입찰 단위<strong><fmt:formatNumber value="${p.join_amt}" pattern="#,##0" />원</strong></div>
								<c:choose>
									<c:when test="${p.buyNowEnabled}">
										<div>즉시구매가<strong><fmt:formatNumber value="${p.limit_amt}" pattern="#,###" />원</strong></div>
									</c:when>
									<c:otherwise>
										<div>시중가<strong><fmt:formatNumber value="${p.curr_amt}" pattern="#,##0" />원</strong></div>
									</c:otherwise>
								</c:choose>
							</div>
						</div>

						<c:if test="${iAmTop && !p.closed}">
							<div class="ma-top-notice" id="topNotice"><i class="bi bi-hand-thumbs-up"></i> 지금 내가 최고 입찰자입니다.</div>
						</c:if>

						<c:choose>
							<%-- 판매자 본인 --%>
							<c:when test="${isOwner}">
								<c:if test="${!p.closed}">
									<div class="ma-login-box">
										<i class="bi bi-person-badge"></i> 내가 등록한 상품입니다.
										<c:if test="${p.join_cnt > 0}"><br><small>입찰이 시작되어 수정 · 삭제할 수 없습니다.</small></c:if>
									</div>
								</c:if>
								<c:if test="${p.join_cnt == 0 && !p.closed}">
									<div class="ma-owner">
										<a class="btn btn-light-ma" href="/web/aucts/modifyProduct?anum=${p.anum}"><i class="bi bi-pencil"></i> 수정</a>
										<form action="/web/aucts/deleteProduct" method="post" onsubmit="return confirm('상품을 삭제할까요?');">
											<input type="hidden" name="anum" value="${p.anum}">
											<button type="submit" class="btn btn-danger-ghost"><i class="bi bi-trash"></i> 삭제</button>
										</form>
									</div>
								</c:if>
							</c:when>
							<c:when test="${p.closed}"></c:when>
							<%-- 비로그인 --%>
							<c:when test="${user == null}">
								<div class="ma-login-box">
									입찰하려면 로그인이 필요합니다.<br>
									<a class="btn btn-primary mt-3" href="/web/users/login">로그인하고 입찰하기</a>
								</div>
							</c:when>
							<%-- 진행 중 --%>
							<c:when test="${status == 'LIVE'}">
								<form class="ma-bid" id="bidForm" onsubmit="return false">
									<c:if test="${p.bidPossible}">
										<div class="row g-2">
											<div class="${p.total_cnt > 1 ? 'col-8' : 'col-12'}">
												<label class="form-label" for="bidPrice">입찰가</label>
												<div class="input-group">
													<input type="text" inputmode="numeric" class="form-control" id="bidPrice" autocomplete="off"
														placeholder="<fmt:formatNumber value='${p.min_bid}' pattern='#,###' />">
													<span class="input-group-text">원</span>
												</div>
											</div>
											<c:if test="${p.total_cnt > 1}">
												<div class="col-4">
													<label class="form-label" for="amount">수량</label>
													<select class="form-select" id="amount">
														<c:forEach begin="1" end="${p.total_cnt}" var="n"><option value="${n}">${n}개</option></c:forEach>
													</select>
												</div>
											</c:if>
										</div>
										<div class="hint" id="bidHint">최소 <b id="minBidText"><fmt:formatNumber value="${p.min_bid}" pattern="#,###" />원</b>부터 입찰할 수 있습니다.</div>
										<button type="button" class="btn btn-primary btn-bid" id="bidBtn"><i class="bi bi-hammer"></i> 입찰하기</button>
										<button type="button" class="btn btn-outline-primary btn-quick" id="minBidBtn">
											최소 금액 <span id="minBidBtnText"><fmt:formatNumber value="${p.min_bid}" pattern="#,###" /></span>원으로 입찰
										</button>
									</c:if>
									<c:if test="${p.buyNowEnabled}">
										<button type="button" class="btn btn-buynow" id="buyNowBtn">
											<i class="bi bi-lightning-charge"></i> 즉시구매 <fmt:formatNumber value="${p.limit_amt}" pattern="#,###" />원
										</button>
										<div class="hint text-center">즉시구매하면 바로 낙찰되고 경매가 끝납니다.</div>
									</c:if>
								</form>
							</c:when>
							<c:when test="${status == 'READY'}">
								<div class="ma-login-box">아직 경매가 시작되지 않았습니다.<br>시작 시간 이후에 입찰할 수 있습니다.</div>
							</c:when>
							<c:otherwise>
								<div class="ma-login-box">마감된 경매입니다. 결과를 확인하는 중입니다…</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<!-- ===== 상품 설명 ===== -->
				<div class="col-12">
					<div class="ma-card ma-desc mt-0">
						<h3>상품 설명</h3>
						<div class="body"><c:out value="${p.contents}" /></div>
						<dl>
							<dt>상품명</dt><dd><c:out value="${p.prod_name}" /></dd>
							<dt>판매 수량</dt><dd>${p.total_cnt}개</dd>
							<dt>경매 기간</dt><dd><c:out value="${fn:substring(p.auct_start, 0, 16)}" /> ~ <c:out value="${fn:substring(p.auct_end, 0, 16)}" /></dd>
							<dt>시중 판매가</dt><dd><fmt:formatNumber value="${p.curr_amt}" pattern="#,##0" />원</dd>
						</dl>
					</div>
				</div>

				<!-- ===== 문의 ===== -->
				<div class="col-12">
					<div class="ma-card ma-qna mt-0">
						<h3>상품 문의 <span class="text-muted fw-normal fs-6">${fn:length(boardList)}</span></h3>

						<c:if test="${user != null}">
							<form class="write" id="boardForm" onsubmit="return false">
								<input id="subject" type="text" class="form-control" maxlength="100" placeholder="제목">
								<textarea id="contents" class="form-control" rows="3" maxlength="1000" placeholder="판매자에게 궁금한 점을 남겨주세요."></textarea>
								<div class="actions">
									<button type="button" class="btn btn-light-ma btn-sm" id="board-cancel">취소</button>
									<button type="button" class="btn btn-primary btn-sm" id="boardCreate" disabled>문의 등록</button>
								</div>
							</form>
						</c:if>

						<c:if test="${empty boardList}">
							<div class="empty">아직 문의가 없습니다.</div>
						</c:if>

						<c:forEach var="board" items="${boardList}">
							<div class="item" data-qnum="${board.qnum}">
								<div class="who">
									<span class="avatar"><c:out value="${fn:substring(board.name, 0, 1)}" /></span>
									<b><c:out value="${board.name}" /></b>
									<time><c:out value="${fn:substring(board.wdate, 0, 16)}" /></time>
								</div>
								<div class="subject"><c:out value="${board.subject}" /></div>
								<p class="text"><c:out value="${board.contents}" /></p>
								<div class="tools">
									<button type="button" class="memo-toggle" ${board.memo_cnt == 0 ? 'hidden' : ''}><i class="bi bi-chat"></i> 답글 ${board.memo_cnt}개</button>
									<c:if test="${user != null}">
										<button type="button" class="memo-write"><i class="bi bi-reply"></i> 답글 쓰기</button>
									</c:if>
								</div>
								<div class="memos"></div>
								<form class="memo-form" onsubmit="return false">
									<input type="text" class="form-control form-control-sm memo-text" maxlength="1000" placeholder="답글을 입력하세요">
									<button type="button" class="btn btn-primary btn-sm memoCreate">등록</button>
								</form>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
	</section>
</main>

<%@ include file="/WEB-INF/views/include/footer.jsp"%>
<script>
(function () {
	const ANUM = ${p.anum};
	let MIN_BID = ${p.min_bid}; // 실시간으로 다른 사람이 입찰하면 바뀐다
	const CLOSED = ${p.closed};
	const START = "${fn:replace(p.auct_start, ' ', 'T')}";
	const END = "${fn:replace(p.auct_end, ' ', 'T')}";
	const JSON_HEADERS = { "Content-Type": "application/json; charset=UTF-8" };

	function post(url, method, body) {
		return fetch(url, { method: method, headers: JSON_HEADERS, body: JSON.stringify(body) })
			.then(async (res) => {
				const text = await res.text();
				if (!res.ok) throw new Error(text || "요청에 실패했습니다.");
				return text;
			});
	}
	const won = (n) => Number(n).toLocaleString("ko-KR");

	// ---------- 사진 슬라이드 ----------
	if (document.querySelector(".detailSwiper")) {
		new Swiper(".detailSwiper", {
			spaceBetween: 0,
			pagination: { el: ".swiper-pagination", clickable: true },
			navigation: { nextEl: ".swiper-button-next", prevEl: ".swiper-button-prev" },
		});
	}

	// ---------- 남은 시간 ----------
	const box = document.getElementById("countDown");
	const boxText = box.querySelector(".text");
	function pad(n) { return String(n).padStart(2, "0"); }
	function tick() {
		const now = new Date(), s = new Date(START), e = new Date(END);
		if (isNaN(s) || isNaN(e)) return;
		let target, prefix;
		if (now < s) { target = s; prefix = "경매 시작까지 "; box.className = "ma-countdown ready"; }
		else if (now < e) { target = e; prefix = "마감까지 "; box.className = "ma-countdown"; }
		else {
			box.className = "ma-countdown ended";
			boxText.textContent = "경매가 마감되었습니다";
			document.querySelectorAll("#bidForm button, #bidForm input, #bidForm select").forEach((b) => (b.disabled = true));
			clearInterval(timer);
			// 서버는 화면을 다시 열 때 바로 낙찰/유찰 처리하므로, 결과를 보여주기 위해 잠시 뒤 새로고침
			if (!CLOSED && !window.__reloading) { window.__reloading = true; setTimeout(() => location.reload(), 3000); }
			return;
		}
		const t = Math.floor((target - now) / 1000);
		const d = Math.floor(t / 86400), h = Math.floor((t % 86400) / 3600), m = Math.floor((t % 3600) / 60), sec = t % 60;
		boxText.textContent = prefix + (d > 0 ? d + "일 " : "") + pad(h) + ":" + pad(m) + ":" + pad(sec);
	}
	const timer = setInterval(tick, 1000);
	tick();

	// ---------- 입찰 ----------
	const amountOf = () => (document.getElementById("amount") ? Number(document.getElementById("amount").value) : 1);
	let busy = false; // 내가 보낸 입찰 · 구매가 처리 중일 때는 실시간 알림을 띄우지 않는다
	const priceInput = document.getElementById("bidPrice");
	if (priceInput) {
		const hint = document.getElementById("bidHint");
		const price = () => Number(priceInput.value.replace(/[^\d]/g, ""));

		priceInput.addEventListener("input", () => {
			const v = price();
			priceInput.value = v ? won(v) : "";
			hint.classList.toggle("text-danger", v > 0 && v < MIN_BID);
		});

		function bid(value) {
			if (!value || value < MIN_BID) {
				alert(won(MIN_BID) + "원 이상으로 입찰해주세요.");
				priceInput.focus();
				return;
			}
			if (!confirm(won(value) + "원에 입찰할까요?")) return;
			busy = true;
			post("/web/product-api/product_auction", "PUT", { anum: ANUM, start_amt: value, amount: amountOf() })
				.then(() => location.reload())
				.catch((err) => { busy = false; alert(err.message); });
		}
		document.getElementById("bidBtn").addEventListener("click", () => bid(price()));
		document.getElementById("minBidBtn").addEventListener("click", () => bid(MIN_BID));
		priceInput.addEventListener("keydown", (e) => { if (e.key === "Enter") bid(price()); });
	}

	// ---------- 즉시구매 ----------
	const buyNowBtn = document.getElementById("buyNowBtn");
	if (buyNowBtn) {
		buyNowBtn.addEventListener("click", () => {
			if (!confirm("즉시구매가로 구매할까요? 바로 낙찰되고 경매가 끝납니다.")) return;
			busy = true;
			buyNowBtn.disabled = true;
			post("/web/product-api/buy_now", "POST", { anum: ANUM, amount: amountOf() })
				.then(() => location.reload())
				.catch((err) => { busy = false; buyNowBtn.disabled = false; alert(err.message); });
		});
	}

	// ---------- 실시간 갱신 (Server-Sent Events) ----------
	function toast(msg, kind) {
		const t = document.createElement("div");
		t.className = "ma-toast " + (kind || "");
		t.textContent = msg;
		document.body.appendChild(t);
		requestAnimationFrame(() => t.classList.add("show"));
		setTimeout(() => { t.classList.remove("show"); setTimeout(() => t.remove(), 300); }, 4000);
	}
	function applyPrice(ev) {
		MIN_BID = ev.min_bid;
		document.getElementById("priceNow").textContent = won(ev.start_amt) + "원";
		document.getElementById("bidCount").textContent = ev.join_cnt + "회";
		const minText = document.getElementById("minBidText"), minBtn = document.getElementById("minBidBtnText");
		if (minText) minText.textContent = won(ev.min_bid) + "원";
		if (minBtn) minBtn.textContent = won(ev.min_bid);
		if (priceInput) priceInput.placeholder = won(ev.min_bid);
		const now = document.getElementById("priceNow");
		now.classList.remove("flash"); void now.offsetWidth; now.classList.add("flash");
	}
	if (window.EventSource && !CLOSED) {
		const es = new EventSource("/web/product-api/stream?anum=" + ANUM);
		const badge = document.getElementById("liveBadge");
		es.addEventListener("hello", () => { badge.hidden = false; });
		es.onerror = () => { badge.hidden = true; }; // 끊기면 브라우저가 알아서 다시 연결
		es.addEventListener("bid", (e) => {
			if (busy) return;
			const ev = JSON.parse(e.data);
			applyPrice(ev);
			const notice = document.getElementById("topNotice");
			if (notice) {
				notice.remove();
				toast("다른 분이 " + won(ev.start_amt) + "원으로 입찰해 최고가가 바뀌었습니다.", "warn");
			} else {
				toast((ev.bidder || "누군가") + "님이 " + won(ev.start_amt) + "원에 입찰했습니다.");
			}
		});
		const onEnd = (e) => {
			if (busy) return;
			const ev = JSON.parse(e.data);
			es.close();
			toast(ev.end_chk === "U" ? "경매가 유찰로 끝났습니다." :
				(ev.end_chk === "B" ? "즉시구매로" : "낙찰로") + " 경매가 끝났습니다. (" + won(ev.win_amt) + "원)", "end");
			document.querySelectorAll("#bidForm button, #bidForm input, #bidForm select").forEach((b) => (b.disabled = true));
			setTimeout(() => location.reload(), 2500);
		};
		es.addEventListener("buy_now", onEnd);
		es.addEventListener("close", onEnd);
	}

	// ---------- 문의 작성 ----------
	const subject = document.getElementById("subject");
	if (subject) {
		const contents = document.getElementById("contents");
		const createBtn = document.getElementById("boardCreate");
		const check = () => (createBtn.disabled = !subject.value.trim() || !contents.value.trim());
		subject.addEventListener("input", check);
		contents.addEventListener("input", check);
		document.getElementById("board-cancel").addEventListener("click", () => { subject.value = ""; contents.value = ""; check(); });
		createBtn.addEventListener("click", () => {
			post("/web/product-api/create_board", "POST", { anum: ANUM, subject: subject.value, contents: contents.value })
				.then(() => location.reload())
				.catch((err) => alert(err.message));
		});
	}

	// ---------- 답글 ----------
	document.querySelectorAll(".ma-qna .item").forEach((item) => {
		const qnum = Number(item.dataset.qnum);
		const memos = item.querySelector(".memos");
		const form = item.querySelector(".memo-form");
		const toggle = item.querySelector(".memo-toggle");
		let loaded = false;

		function load() {
			return post("/web/product-api/memoList", "POST", { qnum: qnum }).then((text) => {
				const list = JSON.parse(text);
				memos.innerHTML = "";
				list.forEach((m) => {
					// 답글은 textContent 로만 넣는다 (스크립트 삽입 방지)
					const row = document.createElement("p");
					const who = document.createElement("b");
					who.textContent = m.name || "회원";
					const time = document.createElement("time");
					time.textContent = String(m.wdate || "").substring(0, 16);
					row.append(who, document.createTextNode(m.memo), time);
					memos.appendChild(row);
				});
				toggle.hidden = list.length === 0;
				toggle.innerHTML = '<i class="bi bi-chat"></i> 답글 ' + list.length + "개";
				loaded = true;
			});
		}

		toggle.addEventListener("click", () => {
			const open = memos.style.display === "block";
			if (open) { memos.style.display = "none"; return; }
			(loaded ? Promise.resolve() : load()).then(() => (memos.style.display = "block"));
		});

		const writeBtn = item.querySelector(".memo-write");
		if (writeBtn) {
			writeBtn.addEventListener("click", () => {
				form.style.display = form.style.display === "flex" ? "none" : "flex";
				if (form.style.display === "flex") form.querySelector(".memo-text").focus();
			});
			const input = form.querySelector(".memo-text");
			const send = () => {
				if (!input.value.trim()) return;
				post("/web/product-api/create_memo", "POST", { qnum: qnum, memo: input.value })
					.then(() => { input.value = ""; return load(); })
					.then(() => (memos.style.display = "block"))
					.catch((err) => alert(err.message));
			};
			form.querySelector(".memoCreate").addEventListener("click", send);
			input.addEventListener("keydown", (e) => { if (e.key === "Enter") send(); });
		}
	});
})();
</script>
</body>
</html>
