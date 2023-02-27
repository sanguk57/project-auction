<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <html>

  <head>
    <meta charset="UTF-8">
    <title>Password 수정</title>
    <link rel="canonical" href="https://getbootstrap.com/docs/5.2/examples/sign-in/">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet"
      integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
  </head>

  <body class="text-center">
    <div class="container test">
      <main class="form-signin w-50 m-auto ">
        <form>
          <input type="hidden" value=${param.unum} id="unum">
          <h1 class="h3 mb-3 fw-normal title">비밀번호 수정</h1>
          <div class="form-floating mt-3">
            <input type="password" class="form-control mt-3" placeholder="영문(대, 소), 특수문자, 숫자 1개 이상포함 8자리이상" id="pw" name="password"> <label
              for="floatingInput">비밀번호</label>
              <p class="invalid-feedback pw_ck m-0"></p>
          </div>
          <div class="form-floating mt-3">
            <input type="password" class="form-control" id="pw_rs" placeholder="Password"> <label
              for="floatingPassword">비밀번호 재확인</label>
              <p class="invalid-feedback pwrs_ck"></p>
          </div>
          <div class="form-floating mt-3">
            <button class="btn btn-sm btn-primary w-100" type="button" id="modifyPassword">비밀번호 수정</button>
          </div>
        </form>
      </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
      integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
      crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.min.js"
      integrity="sha384-IDwe1+LCz02ROU9k972gdyvl+AESN10+x7tBKgc9I5HFtuNz0wWnPclzo6p9vxnk"
      crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
      crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.6.3.min.js"
      integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
    <script>
      $(function () {

        const pw_ckTest = RegExp(
          /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/
        );
        console.log('ok...')
        $('#pw').keyup(function () {
          if (!pw_ckTest.test($('#pw').val())) {
            $('#pw').attr("class","form-control is-invalid");
            $('#pw_rs').attr("disabled", true);
            $(".pw_ck").text("사용할 수 없는 형식입니다.");
            $('#modifyPassword').attr("disabled", true);
          } else
          {
            $('#pw').attr("class","form-control is-valid");
            $('#pw_rs').attr("disabled", false);
          }
          if (!($('#pw_rs').val() === "")) 
          {
            if ($('#pw').val() === $('#pw_rs').val()) {
              $('#pw_rs').attr("class","form-control is-valid");
              $('#pw').attr("class","form-control is-valid");
            }
            else if (!($('#pw').val() === $('#pw_rs').val())) {
              $('#pw').attr("class","form-control");
              $('#pw_rs').attr("class","form-control is-invalid");
              $(".pwrs_ck").text("비밀번호가 일치하지 않습니다.");
              $('#modifyPassword').attr("disabled", true);
            }
          }
          if ($('#pw').val() === "") $('#pw').className = "form-control";
        });
        $('#pw_rs').keyup(function(){

          if (pw.value === pw_rs.value) {
            $('#pw_rs').attr("class","form-control is-valid");
            $('#pw').attr("class","form-control is-valid");
            $('#modifyPassword').attr("disabled", false);
          } else {
            $('#pw').attr("class","form-control");
            $('#pw_rs').attr("class","form-control is-invalid");
            $(".pwrs_ck").text("비밀번호가 일치하지 않습니다.");
            $('#modifyPassword').attr("disabled", true);
          }
        });
  
        $('#modifyPassword').click(function () {
        	var user = {unum: $('#unum').val(), password: $('#pw').val()}
          $.ajax({
            url: "/web/rest/modifyPassword",
            type: "PUT",
            contentType: "application/json; charset=UTF-8",
            dataType: "text",
            data: JSON.stringify(user),
            success: function (data, textStatus) {
              console.log(data, textStatus);
              alert(data);
              close();
            },
            error: function (data, textStatus) {
              console.log(data.responseText, textStatus)
              alert(data.responseText);
            }
          })


        })
      })

    </script>
  </body>

  </html>