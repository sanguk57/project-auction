<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<%@ taglib uri="jakarta.tags.core" prefix="c"%>
	<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입 약관 동의</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
<%@ include file="/WEB-INF/views/include/authHead.jsp"%>
</head>

<body class="ma-auth wide">
  <div class="ma-auth-wrap">
    <a class="ma-auth-logo" href="/web/aucts/index"><i class="bi bi-hammer"></i>MyAuct</a>
    <p class="ma-auth-sub">회원가입 전에 약관을 확인해주세요.</p>
    <div class="ma-auth-card">
      <label for="termsPrivacy" class="collect_personal pb-3 mb-2 border-bottom"><input class="form-check-input me-3 btnAll" type="checkbox" name="ok" id="flexRadioDefault1">이용약관, 개인정보 수집 및 이용에 모두 동의합니다.<span class="terms_choice"></span></label>
        <label for="termsPrivacy" class="collect_personal"><input class="form-check-input me-3 btn1 btn_ok" type="checkbox" name="ok1" id="flexRadioDefault1"> 이용약관 동의<span class="terms_choice">(필수)</span></label>
      <div class="col-12 overflow-auto box mt-2" style="white-space: pre-line">제1조 (목적)
이 약관은 MyAuct(이하 "사이트")가 제공하는 중고 물품 경매 서비스의 이용 조건과 절차를 정합니다.

제2조 (회원)
1. 회원은 아이디와 비밀번호를 직접 관리해야 하며, 다른 사람에게 알려주어서는 안 됩니다.
2. 다른 사람의 정보로 가입하거나 거짓 정보를 입력하면 이용이 제한될 수 있습니다.

제3조 (경매)
1. 판매자는 실제로 판매할 수 있는 물품만 등록해야 하며, 사진과 설명은 사실과 같아야 합니다.
2. 입찰은 "현재 경매가 + 입찰 단위" 이상의 금액으로만 할 수 있고, 판매자는 자기 상품에 입찰할 수 없습니다.
3. 입찰이 한 건이라도 있는 상품은 판매자가 수정하거나 삭제할 수 없습니다.
4. 경매 종료 후 거래(결제, 배송, 직거래)는 판매자와 낙찰자가 직접 진행합니다.

제4조 (금지 행위)
허위 상품 등록, 가격을 올리기 위한 입찰, 욕설·광고성 댓글, 법으로 거래가 금지된 물품의 등록을 금지합니다.

제5조 (책임)
사이트는 거래 당사자가 아니며, 회원 사이의 거래에서 생긴 문제는 당사자끼리 해결하는 것을 원칙으로 합니다.

※ 이 사이트는 개인 포트폴리오용 프로젝트입니다.</div>
        <label for="termsPrivacy" class="collect_personal"><input class="form-check-input me-3 btn1 btn_ok" type="checkbox" name="ok2" id="flexRadioDefault1">개인정보 수집 및 이용 동의<span class="terms_choice">(필수)</span></label>
      <div class="col-12 overflow-auto box mt-2" style="white-space: pre-line">1. 수집 항목
아이디, 비밀번호, 이름, 휴대전화번호, 이메일, 주소, 성별, 생년월일(나이 계산용)

2. 이용 목적
회원 식별과 로그인, 아이디·비밀번호 찾기, 경매 거래 시 판매자·구매자 연락

3. 보관 기간
회원 탈퇴 시까지. 비밀번호는 복구할 수 없는 방식(BCrypt)으로 암호화하여 저장합니다.

4. 동의를 거부할 권리
동의하지 않을 수 있으나, 이 경우 회원가입과 경매 참여가 제한됩니다.</div>
        <div class="row mt-4">
          <div class="col-6">
           <a href="${path}/users/login"><button class="w-100 btn btn-lg btn-secondary mt-3" type="submit">취소</button></a> 
          </div>
            <div class="col-6">
              <a href="${path}/users/register"><button class="w-100 btn btn-lg btn-primary mt-3 ok_chk" type="submit">확인</button></a>
            </div>
        </div>
    </div>
  </div>
  <a href=""></a>
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
    integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
    crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.min.js"
    integrity="sha384-IDwe1+LCz02ROU9k972gdyvl+AESN10+x7tBKgc9I5HFtuNz0wWnPclzo6p9vxnk"
    crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
    crossorigin="anonymous"></script>
    <script src="${path}/js/agree.js" defer></script>
</body>

</html>