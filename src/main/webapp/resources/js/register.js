const btn_idck = document.querySelector(".btn_idck");
const inId = document.querySelector(".id");
const pw = document.querySelector(".pw");
const pw_rs = document.querySelector(".pw_rs");
const btn_sm = document.querySelector(".btn_sm");
const btn_pwck = document.querySelector(".btn_pwck");
const tel_num = document.querySelector(".tel_num");
const btn_phCk = document.querySelector(".btn_phCk");
const email = document.querySelector(".email");
const ok_num = document.querySelector(".ok_num");
const name_input = document.querySelector(".name");
const btn_addr = document.querySelector(".btn_addr")

const name_ckTest = RegExp(/^[가-힣]{2,4}|[a-zA-Z]{2,10}\s[a-zA-Z]{2,10}$/);
const email_chTest = RegExp(
  /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/
);
const pw_ckTest = RegExp(
  /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/
);
const id_ckTest = RegExp(/^(?=.*\d)(?=.*[a-zA-Z])[0-9a-zA-Z]{8,12}$/);
const tel_ckTest = RegExp(/^\d{3}-\d{3,4}-\d{4}$/);

name_input.addEventListener("keyup", () => {
  const name_value = name_input.value;

  if (!name_ckTest.test(name_value)) {
    name_input.className = "form-control name_input is-invalid";
    document.querySelector(".name_ck").textContent = "이름 양식에 맞춰주세요";
  } else {
    name_input.className = "form-control email is-valid";
  }
  if (name_value === "") name_input.className = "form-control name_input";
});

email.addEventListener("keyup", () => {
  const email_value = email.value;

  if (!email_chTest.test(email_value)) {
    email.className = "form-control email is-invalid";
    // email.classList.add("is-invalid")
    document.querySelector(".email_ck").textContent =
      "이메일 양식에 맞춰주세요";
  } else {
    email.className = "form-control email is-valid";
    // email.classList.add("is-valid")
  }
  if (email.value === "") email.className = "form-control email";
  // email.classList.remove("is-invalid", "is-valid")
});

btn_pwck.addEventListener("click", (e) => {
  if (e.target.checked) {
    pw.type = "text";
    pw_rs.type = "text";
  } else {
    pw.type = "password";
    pw_rs.type = "password";
  }
});

	function goPopup() {
		var pop = window.open("/web/users/jusoPopup", "pop",
				"width = 580, height = 300, top = 100, left = 450, scrollbars=yes, resizable=yes");
	}

	function jusoCallBack(roadFullAddr) {
		// 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.
		document.getElementById('roadFullAddr').value = roadFullAddr;
	}

pw.addEventListener("keyup", () => {
  const pw_value = pw.value;

  if (!pw_ckTest.test(pw_value)) {
    pw.className = "form-control pw is-invalid";
    //   pw.classList.add("is-invalid")
    pw_rs.disabled = true;
    document.querySelector(".pw_ck").textContent =
      "사용할 수 없는 형식입니다..";
    btn_sm.disabled = true;
  } else {
    pw.className = "form-control pw is-valid";
    // pw.classList.remove("is-invalid")
    // pw.classList.add("is-valid")
    pw_rs.disabled = false;
  }
  if (!(pw_rs.value === "")) {
    if (pw.value === pw_rs.value) {
      pw_rs.className = "form-control pw_rs is-valid";
      // pw_rs.classList.remove("is-invalid")
      // pw_rs.classList.add("is-valid")
      pw.className = "form-control pw is-valid";
      // pw.classList.remove("is-invalid")
      // pw.classList.add("is-valid")
    } else if (!(pw.value === pw_rs.value)) {
      pw.className = "form-control pw";
      // pw.classList.remove("is-valid", "is-invalid")
      pw_rs.className = "form-control pw_rs is-invalid";
      // pw_rs.classList.add("is-invalid")
      document.querySelector(".pwrs_ck").textContent =
        "비밀번호가 일치하지 않습니다.";
      btn_sm.disabled = true;
    }
  }
  if (pw.value === "") pw.className = "form-control pw";
  // pw.classList.remove("is-valid", "is-invalid")
});
pw_rs.addEventListener("keyup", () => {
  // if(!pw_rs.value===null){
  if (pw.value === pw_rs.value) {
    pw_rs.className = "form-control pw_rs is-valid";
    // pw_rs.classList.add("is-valid")
    pw.className = "form-control pw is-valid";
    // pw.classList.add("is-valid")
  } else {
    pw.className = "form-control pw";
    // pw.classList.remove("is-valid", "is-invalid")
    pw_rs.className = "form-control pw_rs is-invalid";
    // pw_rs.classList.add("is-invalid")
    document.querySelector(".pwrs_ck").textContent =
      "비밀번호가 일치하지 않습니다.";
    btn_sm.disabled = true;
  }
  // }
});

//클래스 포함 여부 확인 [포함시 : true | 미 포함시 : false 리턴]
// element.classList.contains(포함 여부 확인할 클래스);
btn_sm.addEventListener("click", (e) => {
  if (
    inId.classList.contains("is-valid") &&
    pw.classList.contains("is-valid") &&
    ok_num.classList.contains("is-valid") &&
    name_input.classList.contains("is-valid")
  ) {} else {
    e.preventDefault();
    alert("필수항목 확인해주세요");
  }
});

btn_idck.addEventListener("click", () => {
  const id = inId.value;

  fetch("http://localhost:8989/web/rest/userIdChk",{
   method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    "user_id" : id,
  }),
}).then((response) => response.text()).then(funcData => {
  console.log(funcData)
  if(funcData == '0'){
    inId.className = "form-control id is-valid";
    document.querySelector(".valid-feedback").textContent = '사용가능한 아이디 입니다.';
  }
  else{
    btn_sm.disabled = true;
    inId.className = "form-control id is-invalid";
    document.querySelector(".id_ck").textContent = '이미 사용중인 아이디 입니다.';
  }

})
  
  if (id === "") {
    inId.className = "form-control id is-invalid";
    // inId.classList.add("is-invalid")
    document.querySelector(".id_ck").textContent = "아이디를 입력해주세요.";
    btn_sm.disabled = true;
  }
});


inId.addEventListener("keyup", () => {
  const id = inId.value;

  inId.className = "form-control id";
  // inId.classList.remove("is-invalid", "is-valid")
  if (!id_ckTest.test(id)) {
    inId.className = "form-control id is-invalid";
    // inId.classList.add("is-invalid")
    document.querySelector(".id_ck").textContent = "사용할 수 없는 형식입니다.";
    btn_idck.disabled = true;
    btn_sm.disabled = true;
  } else {
    inId.className = "form-control id";
    // inId.classList.remove("is-invalid", "is-valid")
    btn_idck.disabled = false;
  }
  if (id === "") inId.className = "form-control id";
  // inId.classList.remove("is-invalid", "is-valid")
});

tel_num.addEventListener("keyup", () => {
  const tel = tel_num.value;

  if (
    !tel_ckTest.test(tel) ||
    !(pw.value === pw_rs.value) ||
    pw_rs.value === ""
  ) {
    btn_phCk.disabled = true;
    tel_num.className = "form-control tel_num";
    // tel_num.classList.remove("is-invalid", "is-valid")
  } else btn_phCk.disabled = false;
});

var ok_code;
btn_phCk.addEventListener("click", () => {
  tel_num.className = "form-control tel_num is-valid";
  ok_code = Math.round(Math.random() * (99999 - 10000 + 1)) + 10000;
  setTimeout(() => {
    ok_num.value = ok_code;
    ok_num.className = "form-control ok_num is-valid";
    btn_sm.disabled = false;
  }, 2000);
});

if ((pw.value === "" || inId.value === "") || (tel_num === "" || inId.value === "")) {
  btn_sm.disabled = true;
  btn_phCk.disabled = true;
  pw_rs.disabled = true;
  btn_idck.disabled =  true;
}
