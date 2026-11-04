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
					<h2>마이페이지</h2>
					<p class="mb-0"><c:out value="${user.name}" />님의 입찰 · 낙찰 · 판매 현황입니다.</p>
				</div>
			</div>
		</div>

		<section class="ma-section">
			<div class="container">
				<c:if test="${not empty okMsg}">
					<div class="alert alert-success d-flex gap-2 align-items-center"><i class="bi bi-check-circle-fill"></i><c:out value="${okMsg}" /></div>
				</c:if>

				<nav class="ma-mytabs">
					<a href="?tab=bids" class="${tab == 'bids' ? 'on' : ''}"><i class="bi bi-hammer"></i>입찰 내역 <b>${fn:length(bids)}</b></a>
					<a href="?tab=wins" class="${tab == 'wins' ? 'on' : ''}"><i class="bi bi-trophy"></i>낙찰 받은 상품 <b>${fn:length(wins)}</b></a>
					<a href="?tab=sales" class="${tab == 'sales' ? 'on' : ''}"><i class="bi bi-box-seam"></i>판매 현황 <b>${fn:length(sales)}</b></a>
					<a href="/web/aucts/index?key=B"><i class="bi bi-heart"></i>관심 상품</a>
					<a href="?tab=profile" class="${tab == 'profile' ? 'on' : ''}"><i class="bi bi-person-gear"></i>내 정보</a>
				</nav>

				<c:choose>
					<%-- ================= 입찰 내역 ================= --%>
					<c:when test="${tab == 'bids'}">
						<c:choose>
							<c:when test="${empty bids}">
								<div class="ma-empty"><i class="bi bi-hammer"></i>아직 입찰한 상품이 없습니다. <a href="/web/aucts/about?status=live">진행 중인 경매 보기</a></div>
							</c:when>
							<c:otherwise>
								<div class="ma-mylist">
									<c:forEach var="b" items="${bids}">
										<c:set var="ms" value="${b.my_status}" />
										<a class="row-item" href="/web/aucts/productView?anum=${b.anum}">
											<span class="thumb"><c:choose><c:when test="${not empty b.thumb}"><img src="/web/upload/${fn:escapeXml(b.thumb)}" alt=""></c:when><c:otherwise><i class="bi bi-image"></i></c:otherwise></c:choose></span>
											<span class="info">
												<b><c:out value="${b.prod_title}" /></b>
												<small>내 최고 입찰 <fmt:formatNumber value="${b.my_max}" pattern="#,###" />원 · ${b.my_cnt}번 입찰 · <c:out value="${b.time_label}" /></small>
											</span>
											<span class="price"><small>${b.closed ? '낙찰가' : '현재가'}</small><fmt:formatNumber value="${b.closed && b.win_amt != null ? b.win_amt : b.start_amt}" pattern="#,###" />원</span>
											<span class="ma-state ${fn:toLowerCase(ms)}">${ms == 'WON' ? '낙찰' : (ms == 'LOST' ? '패찰' : (ms == 'TOP' ? '최고 입찰' : '추월됨'))}</span>
										</a>
									</c:forEach>
								</div>
							</c:otherwise>
						</c:choose>
					</c:when>

					<%-- ================= 낙찰 받은 상품 ================= --%>
					<c:when test="${tab == 'wins'}">
						<c:choose>
							<c:when test="${empty wins}">
								<div class="ma-empty"><i class="bi bi-trophy"></i>아직 낙찰받은 상품이 없습니다.</div>
							</c:when>
							<c:otherwise>
								<div class="ma-mylist">
									<c:forEach var="w" items="${wins}">
										<div class="row-item">
											<a class="thumb" href="/web/aucts/productView?anum=${w.anum}"><c:choose><c:when test="${not empty w.thumb}"><img src="/web/upload/${fn:escapeXml(w.thumb)}" alt=""></c:when><c:otherwise><i class="bi bi-image"></i></c:otherwise></c:choose></a>
											<span class="info">
												<a href="/web/aucts/productView?anum=${w.anum}"><b><c:out value="${w.prod_title}" /></b></a>
												<small>판매자 <c:out value="${w.other_name}" /> · <a href="tel:${fn:escapeXml(w.other_phone)}"><c:out value="${w.other_phone}" /></a><c:if test="${not empty w.other_email}"> · <c:out value="${w.other_email}" /></c:if></small>
											</span>
											<span class="price"><small>${w.end_chk == 'B' ? '즉시구매' : '낙찰가'}</small><fmt:formatNumber value="${w.win_amt}" pattern="#,###" />원</span>
											<span class="ma-state won">${w.end_chk == 'B' ? '즉시구매' : '낙찰'}</span>
										</div>
									</c:forEach>
								</div>
								<p class="ma-fhint mt-3"><i class="bi bi-info-circle"></i> 결제 · 배송(또는 직거래)은 판매자에게 연락해서 진행해주세요.</p>
							</c:otherwise>
						</c:choose>
					</c:when>

					<%-- ================= 판매 현황 ================= --%>
					<c:when test="${tab == 'sales'}">
						<c:choose>
							<c:when test="${empty sales}">
								<div class="ma-empty"><i class="bi bi-box-seam"></i>아직 등록한 상품이 없습니다. <a href="/web/aucts/productEnrollment">상품 등록하기</a></div>
							</c:when>
							<c:otherwise>
								<div class="ma-mylist">
									<c:forEach var="s" items="${sales}">
										<c:set var="st" value="${s.auct_status}" />
										<div class="row-item">
											<a class="thumb" href="/web/aucts/productView?anum=${s.anum}"><c:choose><c:when test="${not empty s.thumb}"><img src="/web/upload/${fn:escapeXml(s.thumb)}" alt=""></c:when><c:otherwise><i class="bi bi-image"></i></c:otherwise></c:choose></a>
											<span class="info">
												<a href="/web/aucts/productView?anum=${s.anum}"><b><c:out value="${s.prod_title}" /></b></a>
												<small>
													<c:choose>
														<c:when test="${s.win_unum != null}">낙찰자 <c:out value="${s.other_name}" /> · <a href="tel:${fn:escapeXml(s.other_phone)}"><c:out value="${s.other_phone}" /></a><c:if test="${not empty s.other_email}"> · <c:out value="${s.other_email}" /></c:if></c:when>
														<c:otherwise>입찰 ${s.join_cnt}건 · <c:out value="${s.time_label}" /></c:otherwise>
													</c:choose>
												</small>
											</span>
											<span class="price"><small>${s.win_unum != null ? '낙찰가' : '현재가'}</small><fmt:formatNumber value="${s.win_unum != null ? s.win_amt : s.start_amt}" pattern="#,###" />원</span>
											<span class="ma-state ${s.end_chk == 'S' || s.end_chk == 'B' ? 'won' : (s.end_chk == 'U' ? 'lost' : (st == 'LIVE' ? 'top' : 'ready'))}"><c:out value="${s.closed ? s.time_label : (st == 'LIVE' ? '진행 중' : (st == 'READY' ? '시작 전' : '마감 처리 중'))}" /></span>
										</div>
									</c:forEach>
								</div>
							</c:otherwise>
						</c:choose>
					</c:when>

					<%-- ================= 내 정보 ================= --%>
					<c:otherwise>
						<div class="row g-4">
							<div class="col-lg-7">
								<form class="ma-fcard ma-reg" method="post" action="/web/my/profile">
									<h2 class="ma-reg-title"><i class="bi bi-person"></i>내 정보 수정</h2>
									<div class="mb-3">
										<label class="form-label">아이디</label>
										<input type="text" class="form-control" value="${fn:escapeXml(me.user_id)}" disabled>
									</div>
									<div class="row g-3 mb-3">
										<div class="col-sm-6">
											<label class="form-label" for="name">이름 <em>*</em></label>
											<input type="text" class="form-control" id="name" name="name" maxlength="30" value="${fn:escapeXml(me.name)}" required>
										</div>
										<div class="col-sm-6">
											<label class="form-label" for="phone">휴대폰 번호 <em>*</em></label>
											<input type="tel" class="form-control" id="phone" name="phone" maxlength="13" value="${fn:escapeXml(me.phone)}" placeholder="010-1234-5678" required>
										</div>
									</div>
									<div class="mb-3">
										<label class="form-label" for="email">이메일 <span class="opt">선택</span></label>
										<input type="email" class="form-control" id="email" name="email" maxlength="100" value="${fn:escapeXml(me.email)}">
									</div>
									<div class="mb-3">
										<label class="form-label" for="addr">주소 <span class="opt">선택</span></label>
										<input type="text" class="form-control" id="addr" name="addr" maxlength="200" value="${fn:escapeXml(me.addr)}">
									</div>
									<div class="mb-4">
										<span class="form-label d-block">성별 <span class="opt">선택</span></span>
										<div class="ma-seg">
											<input type="radio" class="btn-check" name="gender" id="g_m" value="남자" ${me.gender == '남자' ? 'checked' : ''}><label for="g_m">남자</label>
											<input type="radio" class="btn-check" name="gender" id="g_f" value="여자" ${me.gender == '여자' ? 'checked' : ''}><label for="g_f">여자</label>
											<input type="radio" class="btn-check" name="gender" id="g_x" value="" ${me.gender != '남자' && me.gender != '여자' ? 'checked' : ''}><label for="g_x">선택 안 함</label>
										</div>
									</div>
									<button type="submit" class="btn btn-primary">저장</button>
								</form>
							</div>
							<div class="col-lg-5">
								<form class="ma-fcard ma-reg" method="post" action="/web/my/password">
									<h2 class="ma-reg-title"><i class="bi bi-key"></i>비밀번호 변경</h2>
									<div class="mb-3">
										<label class="form-label" for="currentPassword">현재 비밀번호</label>
										<input type="password" class="form-control" id="currentPassword" name="currentPassword" autocomplete="current-password" required>
									</div>
									<div class="mb-3">
										<label class="form-label" for="newPassword">새 비밀번호</label>
										<input type="password" class="form-control" id="newPassword" name="newPassword" autocomplete="new-password"
											placeholder="영문 · 숫자 · 특수문자 포함 8자 이상" required>
									</div>
									<button type="submit" class="btn btn-primary">변경</button>
								</form>

								<form class="ma-fcard ma-reg ma-danger-zone" method="post" action="/web/my/withdraw"
									onsubmit="return confirm('정말 탈퇴할까요? 개인정보가 지워지고 되돌릴 수 없습니다.');">
									<h2 class="ma-reg-title"><i class="bi bi-door-open"></i>회원 탈퇴</h2>
									<p class="ma-fhint">진행 중인 판매 상품이 있거나 최고 입찰자로 참여 중인 경매가 있으면 탈퇴할 수 없습니다. 탈퇴하면 개인정보는 지워지고 입찰 · 낙찰 기록만 남습니다.</p>
									<div class="mb-3">
										<label class="form-label" for="wpw">비밀번호 확인</label>
										<input type="password" class="form-control" id="wpw" name="password" autocomplete="current-password" required>
									</div>
									<button type="submit" class="btn btn-danger-ghost">탈퇴하기</button>
								</form>
							</div>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</section>
	</main>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>
