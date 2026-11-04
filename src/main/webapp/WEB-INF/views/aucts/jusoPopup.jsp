<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%--
	도로명주소 API(juso.go.kr) 팝업: 검색 결과를 받아 부모 창의 jusoCallBack(주소) 로 넘긴다.
	승인키는 app.properties 의 juso.confmKey (예전: JSP 에 키가 직접 적혀 있어서 재발급할 때마다 코드를 고쳐야 했음)
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>주소 검색</title>
<style>
	body { font-family: "Pretendard", "Malgun Gothic", sans-serif; color: #1e293b; display: flex; align-items: center; justify-content: center; min-height: 90vh; margin: 0; text-align: center; }
	.box { max-width: 380px; padding: 24px; }
	h1 { font-size: 18px; margin: 0 0 8px; }
	p { color: #64748b; font-size: 14px; line-height: 1.6; margin: 0 0 18px; }
	button { border: 0; background: #3157f6; color: #fff; padding: 10px 22px; border-radius: 10px; font-weight: 600; cursor: pointer; }
</style>
</head>
<body>
	<%-- 요청값은 HTML 이스케이프해서 input 에 담고 JS 는 그 값을 읽는다 (예전: JS 에 그대로 출력 → XSS) --%>
	<input type="hidden" id="confmKey" value="${fn:escapeXml(jusoKey)}">
	<input type="hidden" id="inputYn" value="${fn:escapeXml(param.inputYn)}">
	<input type="hidden" id="roadFullAddr" value="${fn:escapeXml(param.roadFullAddr)}">

	<div class="box" id="noKey" hidden>
		<h1>주소 검색을 사용할 수 없습니다</h1>
		<p>주소 검색 API 승인키가 설정되지 않았습니다.<br>주소는 입력칸에 직접 적어주세요.</p>
		<button type="button" onclick="window.close()">창 닫기</button>
	</div>

	<form id="form" name="form" method="post">
		<input type="hidden" name="confmKey" value="">
		<input type="hidden" name="returnUrl" value="">
		<input type="hidden" name="resultType" value="">
	</form>

	<script>
	window.addEventListener("load", function () {
		var key = document.getElementById("confmKey").value;
		if (document.getElementById("inputYn").value === "Y") {
			// 주소를 고르고 돌아온 경우
			if (window.opener && typeof window.opener.jusoCallBack === "function") {
				window.opener.jusoCallBack(document.getElementById("roadFullAddr").value);
			}
			window.close();
			return;
		}
		if (!key) {
			document.getElementById("noKey").hidden = false;
			return;
		}
		document.form.confmKey.value = key;
		document.form.returnUrl.value = location.href;
		document.form.resultType.value = "4"; // 도로명 + 지번 + 상세보기
		document.form.action = "https://business.juso.go.kr/addrlink/addrLinkUrl.do";
		document.form.submit();
	});
	</script>
</body>
</html>
