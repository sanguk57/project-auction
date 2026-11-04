<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <c:set var="path" value="${pageContext.request.contextPath}" />
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>아이디 찾기</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet"
                integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
                crossorigin="anonymous">

        <%@ include file="/WEB-INF/views/include/authHead.jsp"%>
</head>

        <body class="ma-auth">
            <div class="ma-auth-wrap">
                <a class="ma-auth-logo" href="/web/aucts/index"><i class="bi bi-hammer"></i>MyAuct</a>
                <p class="ma-auth-sub">가입할 때 입력한 이름과 휴대폰 번호로<br>아이디를 찾을 수 있습니다.</p>
                <main class="ma-auth-card">
                    <form method="post" onsubmit="return false">
                        <div class="mb-3">
                            <label for="name" class="form-label">이름</label>
                            <input type="text" class="form-control" name="name" id="name" placeholder="홍길동">
                        </div>
                        <div class="mb-4">
                            <label for="phone" class="form-label">휴대폰 번호</label>
                            <input type="tel" class="form-control" id="phone" name="phone" placeholder="010-0000-0000">
                        </div>
                        <button class="btn btn-lg btn-primary w-100" type="button" id="idFind">아이디 찾기</button>
                    </form>
                </main>
            </div>


            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
                crossorigin="anonymous"></script>
            <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
                integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
                crossorigin="anonymous"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.min.js"
                integrity="sha384-IDwe1+LCz02ROU9k972gdyvl+AESN10+x7tBKgc9I5HFtuNz0wWnPclzo6p9vxnk"
                crossorigin="anonymous"></script>
            <script src="https://code.jquery.com/jquery-3.6.3.min.js"
                integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
            <script src="${path}/js/idFind.js?v=<%=System.currentTimeMillis() %>"></script>
        </body>

        </html>