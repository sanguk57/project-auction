<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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

        </head>

        <body>
            <div class="container d-flex justify-content-center align-items-center" style="width:380px;">
                <form class="row g-3" method="post">
                    <div class="col-sm-12 mb-2">
                        <label for="validationServer01" class="form-label">이름</label>
                        <input type="text" class="form-control" name="name" id="name" placeholder="이름">
                    </div>
                    <label for="validationServer02" class="form-label p-0 m-0 ms-2">핸드폰 번호</label>
                    <div class="col-sm-8 mt-2">
                        <input type="text" class="form-control" id="phone" name="phone" placeholder="전화번호">
                    </div>
                    <div class="col-sm-4 m-0">
                        <button class="btn btn-lg btn-primary w-100" type="button">본인인증</button>
                    </div>
                    <div class="col-sm-12">
                        <input type="text" class="form-control" id="validationServer02" placeholder="안증번호">
                    </div>
                    <div class="col-sm-12">
                        <button class="btn btn-lg btn-primary w-100" type="button" id="idFind">아이디 찾기</button>
                    </div>
                </form>
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