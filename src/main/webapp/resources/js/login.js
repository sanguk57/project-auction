const id = document.querySelector(".id");
const pw = document.querySelector(".pw");
const btn_sm = document.querySelector(".btn_sm");
const api_btn = document.querySelector(".api-btn");
const id_ck = document.querySelector(".id_ck")
const login_ck = document.querySelector(".login_ck")

id.addEventListener("keyup", () => {
  if (!(id.value === "") && !(pw.value === "")) btn_sm.disabled = false;
  else btn_sm.disabled = true;
});

pw.addEventListener("keyup", () => {
  if (!(id.value === "") && !(pw.value === "")) btn_sm.disabled = false;
  else btn_sm.disabled = true;
});

// api_btn.addEventListener("click", (e)=>{
//     e.preventDefault()
// })

btn_sm.addEventListener("click", (e) => {
  e.preventDefault();
  // 서버가 비밀번호 확인 + 세션 저장까지 처리하므로 성공하면 이동만 하면 된다
  fetch("/web/rest/loginChk", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ user_id: id.value, password: pw.value }),
  }).then(async (response) => {
    const msg = await response.text();
    if (response.ok) {
      // "아이디 기억하기": 체크했으면 아이디만 30일간 쿠키에 저장 (예전: 읽기만 하고 저장은 안 했음)
      if (id_ck.checked) document.cookie = "id=" + encodeURIComponent(id.value) + "; max-age=" + 60 * 60 * 24 * 30 + "; path=/web";
      else document.cookie = "id=; max-age=0; path=/web";
      location.href = "/web/aucts/index";
    } else {
      alert(msg);
    }
  });
});



function popupId(){
  const url = "/web/users/idFind"
  const name = "idFind"
  const option = "width=520,height=640,top=100,left=450,location=no"
  window.open(url, name, option)
}
function popupPw(){
  const url = "/web/users/passwordFind"
  const name = "pwFind"
  const option = "width=520,height=640,top=100,left=450,location=no"
  window.open(url, name, option)
}



    $(function(){
  var value = getCookie("id");
  $(".id").val(value); 
  
  if($(".id").val() != ""){ // 그 전에 ID를 저장해서 처음 페이지 로딩 시, 입력 칸에 저장된 ID가 표시된 상태라면,
    $(".id_ck").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
  }
  
  function getCookie(cookieName) {
		cookieName = cookieName + '=';
		var cookieData = document.cookie;
		var start = cookieData.indexOf(cookieName);
		var cookieValue = '';
		if (start != -1) { // 쿠키가 존재하면
			start += cookieName.length;
			var end = cookieData.indexOf(';', start); // 못찾으면 -1 반환
			if (end == -1) // 쿠키 값의 마지막 위치 인덱스 번호 설정 
				end = cookieData.length;
			cookieValue = decodeURIComponent(cookieData.substring(start, end)); // value 문자열 읽기
		}
		return (cookieValue);
	}
  
})
