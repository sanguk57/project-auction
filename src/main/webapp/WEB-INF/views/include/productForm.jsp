<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
	상품 등록 / 수정 공통 폼 (productEnrollment.jsp, modifyProduct.jsp 에서 include)
	  aDTO 가 있으면 수정, 없으면 등록
	  categoryList   : 카테고리 목록 (컨트롤러에서 전달)
	  uploadFileList : (수정) 현재 사진 경로 목록
	동작은 /web/js/productForm.js
--%>
<c:set var="isEdit" value="${not empty aDTO}" />
<c:set var="d" value="${aDTO}" />

<form id="productForm" class="ma-pform" action="/web/aucts/${isEdit ? 'productModify' : 'auctionItem'}" method="post"
	enctype="multipart/form-data" novalidate>
	<c:if test="${isEdit}"><input type="hidden" name="anum" value="${d.anum}"></c:if>
	<%-- 서버로 보내는 금액 (화면의 "1,000" 같은 입력값에서 숫자만 골라 넣음) --%>
	<input type="hidden" name="start_amt" id="start_amt" value="${isEdit ? d.start_amt : ''}">
	<input type="hidden" name="join_amt" id="join_amt" value="${isEdit ? d.join_amt : ''}">
	<input type="hidden" name="curr_amt" id="curr_amt" value="${isEdit ? d.curr_amt : 0}">
	<input type="hidden" name="limit_amt" id="limit_amt" value="${isEdit ? d.limit_amt : 0}">
	<input type="hidden" name="limit_type" id="limit_type" value="${isEdit && d.limit_type == 'Y' ? 'Y' : 'N'}">

	<div class="row g-4">
		<div class="col-lg-8">

			<!-- 1. 기본 정보 -->
			<section class="ma-fcard">
				<h3 class="ma-ftitle"><span class="step">1</span>기본 정보</h3>
				<div class="mb-3">
					<label class="form-label" for="prod_title">판매글 제목 <em>*</em></label>
					<input type="text" class="form-control" id="prod_title" name="prod_title" maxlength="100"
						placeholder="예) 아이패드 에어 5세대 팝니다" value="${fn:escapeXml(d.prod_title)}" required>
					<div class="invalid-feedback">판매글 제목을 입력해주세요.</div>
				</div>
				<div class="row g-3">
					<div class="col-md-6">
						<label class="form-label" for="prod_name">상품명 <em>*</em></label>
						<input type="text" class="form-control" id="prod_name" name="prod_name" maxlength="100"
							placeholder="예) 아이패드 에어 5" value="${fn:escapeXml(d.prod_name)}" required>
						<div class="invalid-feedback">상품명을 입력해주세요.</div>
					</div>
					<div class="col-md-6">
						<label class="form-label" for="cnum">카테고리 <em>*</em></label>
						<select class="form-select" id="cnum" name="cnum" required>
							<option value="" ${isEdit ? '' : 'selected'} disabled>카테고리 선택</option>
							<c:forEach var="cat" items="${categoryList}">
								<option value="${cat.cnum}" ${isEdit && d.cnum == cat.cnum ? 'selected' : ''}><c:out value="${cat.category}" /></option>
							</c:forEach>
							<option value="0">+ 새 카테고리 직접 입력</option>
						</select>
						<input type="text" class="form-control mt-2 d-none" id="category" name="category" maxlength="50" placeholder="새 카테고리 이름">
						<div class="invalid-feedback">카테고리를 선택하거나 입력해주세요.</div>
					</div>
				</div>
				<div class="row g-3 mt-1">
					<div class="col-md-6">
						<span class="form-label d-block">상품 상태</span>
						<div class="ma-seg">
							<input type="radio" class="btn-check" name="prod_type" id="pt_n" value="N" ${d.prod_type == 'N' ? 'checked' : ''}>
							<label for="pt_n">새상품</label>
							<input type="radio" class="btn-check" name="prod_type" id="pt_y" value="Y" ${d.prod_type != 'N' ? 'checked' : ''}>
							<label for="pt_y">중고</label>
						</div>
					</div>
					<div class="col-md-6">
						<span class="form-label d-block">A/S</span>
						<div class="ma-seg">
							<input type="radio" class="btn-check" name="as_type" id="as_y" value="Y" ${d.as_type == 'Y' ? 'checked' : ''}>
							<label for="as_y">가능</label>
							<input type="radio" class="btn-check" name="as_type" id="as_n" value="N" ${d.as_type != 'Y' ? 'checked' : ''}>
							<label for="as_n">불가</label>
						</div>
					</div>
				</div>
			</section>

			<!-- 2. 사진 -->
			<section class="ma-fcard">
				<h3 class="ma-ftitle"><span class="step">2</span>사진</h3>
				<c:if test="${isEdit && not empty uploadFileList}">
					<p class="ma-fhint">현재 사진 · 새 사진을 선택하면 <b>모두 새 사진으로 교체</b>됩니다.</p>
					<div class="ma-photos current mb-3">
						<c:forEach var="img" items="${uploadFileList}">
							<div class="ph"><img src="/web/upload/${fn:escapeXml(img)}" alt=""></div>
						</c:forEach>
					</div>
				</c:if>
				<label class="ma-drop" for="ex_file">
					<i class="bi bi-camera"></i>
					<b>사진 선택</b>
					<span>jpg · png · gif, 여러 장 선택 가능 (한 장당 20MB) · 첫 번째 사진이 대표 사진이 됩니다</span>
				</label>
				<input type="file" id="ex_file" name="uploadFile" class="visually-hidden" multiple accept=".jpg,.jpeg,.png,.gif">
				<div class="ma-photos mt-3" id="photoPreview"></div>
			</section>

			<!-- 3. 경매 조건 -->
			<section class="ma-fcard">
				<h3 class="ma-ftitle"><span class="step">3</span>경매 조건</h3>
				<div class="row g-3">
					<div class="col-md-6">
						<label class="form-label" for="start_amt_input">시작 가격 <em>*</em></label>
						<div class="input-group">
							<input type="text" inputmode="numeric" class="form-control money" id="start_amt_input" data-target="start_amt"
								placeholder="10,000" value="${isEdit ? d.start_amt : ''}" required>
							<span class="input-group-text">원</span>
						</div>
						<div class="invalid-feedback">시작 가격을 입력해주세요.</div>
					</div>
					<div class="col-md-6">
						<label class="form-label" for="total_cnt">판매 수량 <em>*</em></label>
						<div class="input-group">
							<input type="number" class="form-control" id="total_cnt" name="total_cnt" min="1" max="999"
								value="${isEdit ? d.total_cnt : 1}" required>
							<span class="input-group-text">개</span>
						</div>
					</div>
					<div class="col-12">
						<label class="form-label" for="join_amt_input">입찰 단위 <em>*</em></label>
						<div class="input-group">
							<input type="text" inputmode="numeric" class="form-control money" id="join_amt_input" data-target="join_amt"
								placeholder="1,000" value="${isEdit ? d.join_amt : ''}" required>
							<span class="input-group-text">원</span>
						</div>
						<div class="ma-chipset mt-2" data-fill="join_amt_input">
							<c:forEach var="n" items="100,500,1000,5000,10000,50000">
								<button type="button" data-value="${n}"><fmt:formatNumber value="${n}" pattern="#,###" />원</button>
							</c:forEach>
						</div>
						<p class="ma-fhint mt-2 mb-0">입찰할 때마다 최소 이만큼은 올려야 합니다.</p>
					</div>
					<div class="col-md-6">
						<label class="form-label" for="curr_amt_input">시중 판매가 <span class="opt">선택</span></label>
						<div class="input-group">
							<input type="text" inputmode="numeric" class="form-control money" id="curr_amt_input" data-target="curr_amt"
								placeholder="새 제품 기준 가격" value="${isEdit && d.curr_amt > 0 ? d.curr_amt : ''}">
							<span class="input-group-text">원</span>
						</div>
					</div>
					<div class="col-md-6">
						<label class="form-label d-flex justify-content-between align-items-center" for="limitSwitch">
							<span>즉시구매가 <span class="opt">선택</span></span>
							<span class="form-check form-switch m-0">
								<input class="form-check-input" type="checkbox" role="switch" id="limitSwitch" ${isEdit && d.limit_type == 'Y' ? 'checked' : ''}>
							</span>
						</label>
						<div class="input-group">
							<input type="text" inputmode="numeric" class="form-control money" id="limit_amt_input" data-target="limit_amt"
								placeholder="사용 안 함" value="${isEdit && d.limit_amt > 0 ? d.limit_amt : ''}" ${isEdit && d.limit_type == 'Y' ? '' : 'disabled'}>
							<span class="input-group-text">원</span>
						</div>
						<div class="invalid-feedback">즉시구매가는 시작 가격보다 높아야 합니다.</div>
					</div>
				</div>
			</section>

			<!-- 4. 경매 기간 -->
			<section class="ma-fcard">
				<h3 class="ma-ftitle"><span class="step">4</span>경매 기간</h3>
				<div class="row g-3">
					<div class="col-md-6">
						<label class="form-label" for="auct_start">시작 <em>*</em></label>
						<div class="input-group">
							<span class="input-group-text"><i class="bi bi-calendar-event"></i></span>
							<input type="text" class="form-control" id="auct_start" name="auct_start" autocomplete="off"
								placeholder="날짜와 시간 선택" value="${isEdit ? fn:substring(d.auct_start, 0, 16) : ''}" required>
						</div>
					</div>
					<div class="col-md-6">
						<label class="form-label" for="auct_end">종료 <em>*</em></label>
						<div class="input-group">
							<span class="input-group-text"><i class="bi bi-calendar-check"></i></span>
							<input type="text" class="form-control" id="auct_end" name="auct_end" autocomplete="off"
								placeholder="날짜와 시간 선택" value="${isEdit ? fn:substring(d.auct_end, 0, 16) : ''}" required>
						</div>
						<div class="invalid-feedback">종료 시간은 시작 시간보다 뒤여야 합니다.</div>
					</div>
				</div>
				<div class="ma-chipset mt-3" id="durationChips">
					<button type="button" data-now="1"><i class="bi bi-lightning"></i> 지금 시작</button>
					<button type="button" data-days="1">1일</button>
					<button type="button" data-days="3">3일</button>
					<button type="button" data-days="7">7일</button>
					<button type="button" data-days="14">14일</button>
				</div>
				<p class="ma-fhint mt-2 mb-0" id="durationText">&nbsp;</p>
			</section>

			<!-- 5. 거래 방법 -->
			<section class="ma-fcard">
				<h3 class="ma-ftitle"><span class="step">5</span>거래 방법</h3>
				<div class="row g-3">
					<div class="col-md-5">
						<span class="form-label d-block">거래 방식</span>
						<div class="ma-seg">
							<input type="radio" class="btn-check" name="trans_type" id="tt_y" value="Y" ${d.trans_type != 'N' ? 'checked' : ''}>
							<label for="tt_y"><i class="bi bi-truck"></i> 택배</label>
							<input type="radio" class="btn-check" name="trans_type" id="tt_n" value="N" ${d.trans_type == 'N' ? 'checked' : ''}>
							<label for="tt_n"><i class="bi bi-people"></i> 직거래</label>
						</div>
					</div>
					<div class="col-md-7">
						<label class="form-label" for="roadFullAddr">판매 지역</label>
						<div class="input-group">
							<input type="text" class="form-control" id="roadFullAddr" name="sales_addr" maxlength="200"
								placeholder="예) 서울특별시 강남구" value="${fn:escapeXml(d.sales_addr)}">
							<button class="btn btn-light-ma" type="button" id="addrBtn"><i class="bi bi-search"></i> 주소 검색</button>
						</div>
					</div>
				</div>
			</section>

			<!-- 6. 상세 설명 -->
			<section class="ma-fcard">
				<h3 class="ma-ftitle"><span class="step">6</span>상세 설명</h3>
				<textarea class="form-control" id="contents" name="contents" rows="7" maxlength="2000"
					placeholder="사용 기간, 상태(흠집 · 고장 여부), 구성품, 거래 시 참고할 내용을 적어주세요."><c:out value="${d.contents}" /></textarea>
				<div class="ma-fhint text-end mt-1"><span id="contentsCount">0</span> / 2,000</div>
			</section>
		</div>

		<!-- 미리보기 + 등록 버튼 -->
		<div class="col-lg-4">
			<aside class="ma-summary">
				<div class="ma-fhint mb-2">목록에 이렇게 보여요</div>
				<article class="auct-card">
					<div class="auct-thumb" id="pvThumb">
						<c:choose>
							<c:when test="${isEdit && not empty uploadFileList}"><img src="/web/upload/${fn:escapeXml(uploadFileList[0])}" alt=""></c:when>
							<c:otherwise><div class="auct-thumb-empty"><i class="bi bi-image"></i>사진 없음</div></c:otherwise>
						</c:choose>
						<span class="auct-badge auct-badge-live" id="pvBadge">진행 중</span>
					</div>
					<div class="auct-body">
						<span class="auct-cat" id="pvCat">카테고리</span>
						<h3 class="auct-title" id="pvTitle">판매글 제목</h3>
						<div class="auct-price"><span>시작가</span><strong id="pvPrice">0원</strong></div>
						<div class="auct-meta"><span><i class="bi bi-hammer"></i>입찰 단위 <b id="pvUnit">-</b></span><span id="pvTime"><i class="bi bi-clock"></i>기간 미정</span></div>
					</div>
				</article>
				<button type="submit" class="btn btn-primary btn-lg w-100 mt-3" id="submitBtn">
					<i class="bi bi-check2-circle"></i> ${isEdit ? '수정 내용 저장' : '경매 상품 등록하기'}
				</button>
				<a class="btn btn-light-ma w-100 mt-2" href="${isEdit ? '/web/aucts/productView?anum=' += d.anum : '/web/aucts/index'}">취소</a>
				<c:if test="${isEdit}"><p class="ma-fhint mt-3 mb-0">입찰이 시작된 상품은 수정할 수 없습니다.</p></c:if>
			</aside>
		</div>
	</div>
</form>
