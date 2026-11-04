/*
 * 회원가입 정보 입력 (users/register.jsp)
 *
 * 예전 코드의 문제
 *  - "가입하기" 버튼이 전화번호 칸을 입력할 때만 켜져서, 입력 순서에 따라 가입이 안 됐음
 *  - 전화번호는 "010-1234-5678" 형식만 통과 (하이픈 없이 쓰면 이유도 모른 채 실패)
 *  - 이름 검사 정규식 오류로 "홍길동123" 도 통과, 생년월일은 서버 필수인데 선택처럼 보였음
 *  - 성별을 고르지 않으면 "성별" 이라는 글자가 그대로 저장됐음
 * 지금
 *  - 버튼은 항상 누를 수 있고, 누르면 모든 칸을 검사해서 틀린 칸으로 이동
 *  - 칸에서 벗어날 때(blur)마다 바로 결과 표시, 전화번호는 하이픈 자동 입력
 *  - 아이디 · 비밀번호 규칙은 서버(UserController)와 같음
 */
(function () {
	const $ = (id) => document.getElementById(id);
	const form = $("registerForm");

	const RULE = {
		id: /^(?=.*\d)(?=.*[a-zA-Z])[0-9a-zA-Z]{8,12}$/,
		pw: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/,
		name: /^([가-힣]{2,10}|[a-zA-Z]{2,20}( [a-zA-Z]{1,20}){0,2})$/,
		phone: /^01[016789]-\d{3,4}-\d{4}$/,
		email: /^[\w.+-]+@[\w-]+(\.[\w-]+)+$/,
	};

	// 칸 아래 안내 문구 + 테두리 색
	function show(id, ok, msg) {
		const el = $(id);
		const box = form.querySelector('.ma-msg[data-for="' + id + '"]');
		el.classList.toggle("is-valid", ok === true);
		el.classList.toggle("is-invalid", ok === false);
		if (box) {
			box.textContent = msg || "";
			box.className = "ma-msg" + (ok === true ? " ok" : ok === false ? " bad" : "");
		}
		return ok !== false;
	}

	// ---------- 아이디 ----------
	const idInput = $("user_id");
	let checkedId = null; // 중복 확인을 통과한 아이디

	function validateIdFormat() {
		const v = idInput.value.trim();
		if (!v) return show("user_id", false, "아이디를 입력해주세요.");
		if (!RULE.id.test(v)) return show("user_id", false, "영문과 숫자를 섞어 8~12자로 입력해주세요.");
		if (checkedId === v) return show("user_id", true, "사용할 수 있는 아이디입니다.");
		return show("user_id", null, "중복 확인을 눌러주세요.");
	}
	idInput.addEventListener("input", () => { checkedId = null; validateIdFormat(); });

	function checkDuplicate() {
		if (!validateIdFormat() || !RULE.id.test(idInput.value.trim())) return Promise.resolve(false);
		const v = idInput.value.trim();
		$("idCheckBtn").disabled = true;
		return fetch("/web/rest/userIdChk", {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ user_id: v }),
		})
			.then((res) => res.text())
			.then((cnt) => {
				// 결과가 오기 전에 아이디를 바꿨으면 예전 아이디의 결과는 버린다
				if (idInput.value.trim() !== v) return validateIdFormat();
				if (cnt.trim() === "0") {
					checkedId = v;
					return show("user_id", true, "사용할 수 있는 아이디입니다.");
				}
				checkedId = null;
				return show("user_id", false, "이미 사용 중인 아이디입니다.");
			})
			.catch(() => show("user_id", false, "확인 중 오류가 났습니다. 다시 시도해주세요."))
			.finally(() => ($("idCheckBtn").disabled = false));
	}
	$("idCheckBtn").addEventListener("click", checkDuplicate);

	// ---------- 비밀번호 ----------
	const pw = $("password");
	const pw2 = $("password2");
	const rules = {
		len: (v) => v.length >= 8,
		alpha: (v) => /[A-Za-z]/.test(v),
		digit: (v) => /\d/.test(v),
		special: (v) => /[@$!%*#?&]/.test(v),
	};
	function validatePw() {
		const v = pw.value;
		document.querySelectorAll("#pwRules li").forEach((li) => li.classList.toggle("ok", rules[li.dataset.rule](v)));
		const ok = RULE.pw.test(v);
		pw.classList.toggle("is-valid", ok);
		pw.classList.toggle("is-invalid", v !== "" && !ok);
		return ok;
	}
	function validatePw2() {
		if (!pw2.value) return show("password2", pw.value ? false : null, pw.value ? "비밀번호를 한 번 더 입력해주세요." : "");
		return pw.value === pw2.value
			? show("password2", true, "비밀번호가 일치합니다.")
			: show("password2", false, "비밀번호가 일치하지 않습니다.");
	}
	pw.addEventListener("input", () => { validatePw(); if (pw2.value) validatePw2(); });
	pw2.addEventListener("input", validatePw2);

	$("pwToggle").addEventListener("click", () => {
		const hidden = pw.type === "password";
		pw.type = pw2.type = hidden ? "text" : "password";
		$("pwToggle").innerHTML = hidden ? '<i class="bi bi-eye-slash"></i> 숨기기' : '<i class="bi bi-eye"></i> 보기';
	});

	// ---------- 이름 · 생년월일 ----------
	function validateName() {
		const v = $("name").value.trim();
		if (!v) return show("name", false, "이름을 입력해주세요.");
		return RULE.name.test(v) ? show("name", true, "") : show("name", false, "한글 2~10자 또는 영문 이름으로 입력해주세요.");
	}
	function validateBirth() {
		const v = $("birth").value;
		if (!v) return show("birth", false, "생년월일을 선택해주세요.");
		const d = new Date(v), now = new Date();
		if (isNaN(d) || d > now || d.getFullYear() < 1900) return show("birth", false, "생년월일을 확인해주세요.");
		return show("birth", true, "");
	}
	$("name").addEventListener("blur", validateName);
	$("birth").addEventListener("change", validateBirth);
	$("birth").max = new Date().toISOString().slice(0, 10);

	// ---------- 휴대폰 (하이픈 자동) · 이메일 ----------
	const phone = $("phone");
	phone.addEventListener("input", () => {
		const d = phone.value.replace(/\D/g, "").slice(0, 11);
		phone.value = d.length < 4 ? d : d.length < 8 ? d.slice(0, 3) + "-" + d.slice(3)
			: d.slice(0, 3) + "-" + d.slice(3, d.length - 4) + "-" + d.slice(d.length - 4);
		if (phone.classList.contains("is-invalid")) validatePhone();
	});
	function validatePhone() {
		const v = phone.value.trim();
		if (!v) return show("phone", false, "휴대폰 번호를 입력해주세요.");
		return RULE.phone.test(v) ? show("phone", true, "") : show("phone", false, "올바른 휴대폰 번호가 아닙니다.");
	}
	phone.addEventListener("blur", validatePhone);

	function validateEmail() {
		const v = $("email").value.trim();
		if (!v) return show("email", null, "");
		return RULE.email.test(v) ? show("email", true, "") : show("email", false, "이메일 형식을 확인해주세요.");
	}
	$("email").addEventListener("blur", validateEmail);

	// ---------- 주소 ----------
	$("addrBtn").addEventListener("click", () => {
		window.open("/web/users/jusoPopup", "pop", "width=570,height=420,scrollbars=yes,resizable=yes");
	});
	window.jusoCallBack = (addr) => ($("roadFullAddr").value = addr);

	// ---------- 가입 ----------
	form.addEventListener("submit", async (e) => {
		e.preventDefault();
		const results = [
			["user_id", validateIdFormat() && RULE.id.test(idInput.value.trim())],
			["password", validatePw()],
			["password2", validatePw2()],
			["name", validateName()],
			["birth", validateBirth()],
			["phone", validatePhone()],
			["email", validateEmail()],
		];
		if (!pw.value) pw.classList.add("is-invalid");

		// 아이디 형식이 맞는데 중복 확인을 안 했으면 대신 확인
		if (results[0][1] && checkedId !== idInput.value.trim()) {
			results[0][1] = await checkDuplicate();
		}

		const firstBad = results.find(([, ok]) => !ok);
		if (firstBad) {
			const el = $(firstBad[0]);
			el.scrollIntoView({ behavior: "smooth", block: "center" });
			el.focus({ preventScroll: true });
			return;
		}
		$("submitBtn").disabled = true; // 두 번 눌러 중복 가입되지 않게
		$("submitBtn").innerHTML = '<span class="spinner-border spinner-border-sm"></span> 가입 중...';
		form.submit();
	});
})();
