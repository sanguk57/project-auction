<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
	상품 카드 목록 + 페이지 번호 (index.jsp, about.jsp 에서 include)
	include 하기 전에 정해둘 값
	  listPath   : 페이지 번호 링크 주소 (index / about)
	  showSearch : true 면 목록 위에 검색창 표시
--%>
<c:choose>
	<c:when test="${param.key == 'A'}"><c:set var="listTitle" value="내 등록 상품" /></c:when>
	<c:when test="${param.key == 'B'}"><c:set var="listTitle" value="관심 상품" /></c:when>
	<c:when test="${not empty param.value}"><c:set var="listTitle" value="'${param.value}' 검색 결과" /></c:when>
	<c:otherwise><c:set var="listTitle" value="${listPath == 'about' ? '전체 경매' : '지금 진행 중인 경매'}" /></c:otherwise>
</c:choose>
<c:set var="query" value="&cntPerPage=${paging.cntPerPage}&value=${fn:escapeXml(param.value)}&key=${fn:escapeXml(param.key)}" />

<div class="ma-section-head">
	<h2><c:out value="${listTitle}" /><span class="count" id="listCount" data-count="${paging.total}">${paging.total}건</span></h2>
	<div class="ma-toolbar">
		<c:if test="${showSearch}">
			<form action="${listPath}" method="get" class="form-search">
				<input type="text" name="value" class="form-control" placeholder="상품명 또는 카테고리" value="${fn:escapeXml(param.value)}">
				<button type="submit" class="btn btn-primary"><i class="bi bi-search"></i></button>
			</form>
		</c:if>
		<select id="cntPerPage" class="form-select" aria-label="한 페이지에 보여줄 개수">
			<c:forEach var="n" items="8,12,16,24">
				<option value="${n}" ${paging.cntPerPage == n ? 'selected' : ''}>${n}개씩</option>
			</c:forEach>
		</select>
		<a class="btn btn-primary" href="${user == null ? '/web/users/login' : '/web/aucts/productEnrollment'}"><i class="bi bi-plus-lg"></i> 상품 등록</a>
	</div>
</div>

<c:choose>
	<c:when test="${empty productList}">
		<div class="ma-empty">
			<i class="bi bi-inbox"></i>
			<c:choose>
				<c:when test="${param.key == 'B'}">아직 찜한 상품이 없습니다. 마음에 드는 상품의 하트를 눌러보세요.</c:when>
				<c:when test="${param.key == 'A'}">아직 등록한 상품이 없습니다.</c:when>
				<c:otherwise>조건에 맞는 상품이 없습니다.</c:otherwise>
			</c:choose>
		</div>
	</c:when>
	<c:otherwise>
		<div class="row g-4" id="productGrid" data-login="${user != null}" data-key="${fn:escapeXml(param.key)}">
			<c:forEach var="product" items="${productList}">
				<c:set var="status" value="${product.auct_status}" />
				<div class="col-xl-3 col-lg-4 col-sm-6">
					<article class="auct-card ${status == 'ENDED' ? 'is-ended' : ''}">
						<div class="auct-thumb">
							<c:choose>
								<c:when test="${not empty product.thumb}">
									<img src="/web/upload/${fn:escapeXml(product.thumb)}" alt="" loading="lazy">
								</c:when>
								<c:otherwise>
									<div class="auct-thumb-empty"><i class="bi bi-image"></i>사진 없음</div>
								</c:otherwise>
							</c:choose>
							<span class="auct-badge auct-badge-${fn:toLowerCase(status)}">
								${status == 'LIVE' ? '진행 중' : (status == 'READY' ? '시작 전' : '마감')}
							</span>
						</div>
						<c:if test="${user != null}">
							<button type="button" class="auct-like" data-anum="${product.anum}" aria-label="관심 상품">
								<i class="bi bi-heart"></i>
							</button>
						</c:if>
						<div class="auct-body">
							<span class="auct-cat"><c:out value="${product.category}" /></span>
							<h3 class="auct-title">
								<a href="/web/aucts/productView?anum=${product.anum}"><c:out value="${product.prod_title}" /></a>
							</h3>
							<div class="auct-price">
								<span>현재가</span>
								<strong><fmt:formatNumber value="${product.start_amt}" pattern="#,###" />원</strong>
							</div>
							<div class="auct-meta">
								<span><i class="bi bi-hammer"></i>입찰 ${product.join_cnt}</span>
								<span class="${status == 'LIVE' ? 'time-live' : ''}"><i class="bi bi-clock"></i><c:out value="${product.time_label}" /></span>
							</div>
						</div>
					</article>
				</div>
			</c:forEach>
		</div>
	</c:otherwise>
</c:choose>

<c:if test="${paging.lastPage > 1}">
	<nav aria-label="페이지">
		<ul class="pagination justify-content-center ma-pagination">
			<c:if test="${paging.startPage != 1}">
				<li class="page-item"><a class="page-link" href="/web/aucts/${listPath}?nowPage=${paging.startPage - 1}${query}" aria-label="이전"><i class="bi bi-chevron-left"></i></a></li>
			</c:if>
			<c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="p">
				<li class="page-item ${p == paging.nowPage ? 'active' : ''}">
					<a class="page-link" href="/web/aucts/${listPath}?nowPage=${p}${query}">${p}</a>
				</li>
			</c:forEach>
			<c:if test="${paging.endPage != paging.lastPage}">
				<li class="page-item"><a class="page-link" href="/web/aucts/${listPath}?nowPage=${paging.endPage + 1}${query}" aria-label="다음"><i class="bi bi-chevron-right"></i></a></li>
			</c:if>
		</ul>
	</nav>
</c:if>
