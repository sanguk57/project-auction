<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%-- 도로명주소 API(juso.go.kr) 팝업: 검색 결과를 받아 부모 창의 jusoCallBack(주소) 로 넘긴다 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>주소 검색</title>
</head>
<body>
	<%--
		예전: opener.jusoCallBack("<%=roadFullAddr%>") 처럼 요청값을 자바스크립트에 그대로 출력
		→ 주소에 따옴표와 스크립트를 넣으면 실행되는 XSS. 지금은 HTML 이스케이프한 값을 input 에서 읽는다.
	--%>
	<input type="hidden" id="inputYn" value="${fn:escapeXml(param.inputYn)}">
	<input type="hidden" id="roadFullAddr" value="${fn:escapeXml(param.roadFullAddr)}">

	<form id="form" name="form" method="post">
		<input type="hidden" id="confmKey" name="confmKey" value="">
		<input type="hidden" id="returnUrl" name="returnUrl" value="">
		<input type="hidden" id="resultType" name="resultType" value="">
	</form>

	<script>
	window.addEventListener("load", function () {
		var confmKey = "devU01TX0FVVEgyMDIzMDEzMDExMzcyMzExMzQ1ODQ=";
		var resultType = "4"; // 4 : 도로명 + 지번 + 상세보기
		if (document.getElementById("inputYn").value !== "Y") {
			document.form.confmKey.value = confmKey;
			document.form.returnUrl.value = location.href;
			document.form.resultType.value = resultType;
			document.form.action = "https://business.juso.go.kr/addrlink/addrLinkUrl.do";
			document.form.submit();
		} else {
			if (window.opener && typeof window.opener.jusoCallBack === "function") {
				window.opener.jusoCallBack(document.getElementById("roadFullAddr").value);
			}
			window.close();
		}
	});
	</script>
</body>
</html>
