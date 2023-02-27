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
  fetch("http://localhost:8989/web/rest/loginChk", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    "user_id" : ""+id.value,
    "password" : ""+pw.value,
  }),
}).then((response) => response.text()).then(funcData => {
  console.log(funcData)
  if(funcData === "로그인 성공"){
    var form = document.createElement('form');
   	form.style.display= 'none';
	var objs;
	objs = document.createElement('input'); 
	objs.setAttribute('type', 'text'); 
	objs.setAttribute('name', 'user_id'); 
	objs.setAttribute('value', id.value); 
	form.appendChild(objs);	
	form.setAttribute('method', 'post'); 
	form.setAttribute('action', "/web/aucts/loginUser"); 
	document.body.appendChild(form);
	form.submit();
  }
})
});



function popupId(){
  const url = "http://localhost:8989/web/users/idFind"
  const name = "idFind"
  const option = "width = 580, height = 300, top = 300, left = 450, location = no"
  window.open(url, name, option)
}
function popupPw(){
  const url = "http://localhost:8989/web/users/passwordFind"
  const name = "pwFind"
  const option = `width = 580, height = 300, top =300, left = 450, location = no`
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
			cookieValue = cookieData.substring(start, end); // value 문자열 읽기
		}
		return (cookieValue);
	}
  
})
