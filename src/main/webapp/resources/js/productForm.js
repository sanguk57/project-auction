/*
 * 상품 등록 / 수정 폼 (include/productForm.jsp)
 *  - 금액 입력칸: 화면에는 "10,000" 처럼 보여주고, 숫자만 hidden 칸(start_amt 등)에 넣어 서버로 보냄
 *  - 입찰 단위 / 경매 기간 빠른 선택, 즉시구매 스위치, 사진 미리보기, 오른쪽 미리보기 카드
 *  - 전송 전에 입력값 검사 (서버에서도 다시 검사함)
 */
(function () {
	const form = document.getElementById("productForm");
	if (!form) return;
	const $ = (id) => document.getElementById(id);
	const won = (n) => Number(n).toLocaleString("ko-KR");
	const digits = (s) => String(s || "").replace(/[^\d]/g, "");

	// ---------- 금액 입력 ----------
	function syncMoney(input) {
		const v = digits(input.value);
		input.value = v ? won(v) : "";
		$(input.dataset.target).value = v || (input.dataset.target === "start_amt" || input.dataset.target === "join_amt" ? "" : 0);
	}
	form.querySelectorAll("input.money").forEach((input) => {
		if (input.value) syncMoney(input);
		input.addEventListener("input", () => { syncMoney(input); preview(); });
	});

	// 입찰 단위 빠른 선택
	form.querySelectorAll(".ma-chipset[data-fill] button").forEach((btn) => {
		btn.addEventListener("click", () => {
			const input = $(btn.parentElement.dataset.fill);
			input.value = btn.dataset.value;
			syncMoney(input);
			setInvalid(input, false);
			markChips();
			preview();
		});
	});
	function markChips() {
		const v = $("join_amt").value;
		form.querySelectorAll(".ma-chipset[data-fill] button").forEach((b) => b.classList.toggle("on", b.dataset.value === v));
	}
	$("join_amt_input").addEventListener("input", markChips);

	// ---------- 카테고리 직접 입력 ----------
	const cnum = $("cnum");
	const newCat = $("category");
	cnum.addEventListener("change", () => {
		const custom = cnum.value === "0";
		newCat.classList.toggle("d-none", !custom);
		if (custom) newCat.focus(); else newCat.value = "";
		preview();
	});
	newCat.addEventListener("input", preview);

	// ---------- 즉시구매 ----------
	const limitSwitch = $("limitSwitch");
	const limitInput = $("limit_amt_input");
	limitSwitch.addEventListener("change", () => {
		const on = limitSwitch.checked;
		$("limit_type").value = on ? "Y" : "N";
		limitInput.disabled = !on;
		limitInput.placeholder = on ? "즉시구매 가격" : "사용 안 함";
		if (on) limitInput.focus();
		else { limitInput.value = ""; $("limit_amt").value = 0; setInvalid(limitInput, false); }
	});

	// ---------- 경매 기간 ----------
	const pad = (n) => String(n).padStart(2, "0");
	const fmt = (d) => d.getFullYear() + "-" + pad(d.getMonth() + 1) + "-" + pad(d.getDate()) + " " + pad(d.getHours()) + ":" + pad(d.getMinutes());
	const parse = (s) => { const d = new Date(String(s).replace(" ", "T")); return isNaN(d) ? null : d; };
	const start = $("auct_start");
	const end = $("auct_end");

	if (window.jQuery && jQuery.fn.datetimepicker) {
		jQuery.datetimepicker.setLocale("ko");
		const opts = { format: "Y-m-d H:i", step: 30, scrollMonth: false, scrollInput: false, onChangeDateTime: () => { durationText(); preview(); } };
		jQuery(start).datetimepicker(opts);
		jQuery(end).datetimepicker(opts);
	}
	[start, end].forEach((el) => el.addEventListener("change", () => { durationText(); preview(); }));

	document.querySelectorAll("#durationChips button").forEach((btn) => {
		btn.addEventListener("click", () => {
			if (btn.dataset.now) {
				const d = new Date();
				d.setMinutes(Math.ceil((d.getMinutes() + 1) / 10) * 10, 0, 0); // 다음 10분 단위
				start.value = fmt(d);
			} else {
				let s = parse(start.value);
				if (!s) { s = new Date(); s.setMinutes(Math.ceil((s.getMinutes() + 1) / 10) * 10, 0, 0); start.value = fmt(s); }
				end.value = fmt(new Date(s.getTime() + Number(btn.dataset.days) * 86400000));
			}
			durationText();
			preview();
		});
	});

	function durationText() {
		const s = parse(start.value), e = parse(end.value), out = $("durationText");
		// 버튼 · 달력으로 값이 채워지면 input 이벤트가 없으므로 여기서 오류 표시를 지운다
		if (s) setInvalid(start, false);
		if (s && e && e > s) setInvalid(end, false);
		if (!s || !e) { out.innerHTML = "&nbsp;"; return; }
		const h = Math.round((e - s) / 3600000);
		out.textContent = h <= 0 ? "종료 시간이 시작 시간보다 앞서 있습니다." :
			"경매 기간: " + (h >= 24 ? Math.floor(h / 24) + "일 " + (h % 24 ? (h % 24) + "시간" : "") : h + "시간");
		out.classList.toggle("text-danger", h <= 0);
	}

	// ---------- 사진 ----------
	const fileInput = $("ex_file");
	const photoBox = $("photoPreview");
	fileInput.addEventListener("change", () => {
		photoBox.innerHTML = "";
		for (const f of fileInput.files) {
			if (!/\.(jpe?g|png|gif)$/i.test(f.name)) { alert("이미지 파일(jpg, png, gif)만 올릴 수 있습니다: " + f.name); fileInput.value = ""; photoBox.innerHTML = ""; preview(); return; }
			if (f.size > 20 * 1024 * 1024) { alert("사진 한 장은 20MB 까지 올릴 수 있습니다: " + f.name); fileInput.value = ""; photoBox.innerHTML = ""; preview(); return; }
		}
		[...fileInput.files].forEach((f, i) => {
			const ph = document.createElement("div");
			ph.className = "ph";
			const img = document.createElement("img");
			img.alt = "";
			img.src = URL.createObjectURL(f);
			ph.appendChild(img);
			if (i === 0) { const tag = document.createElement("span"); tag.textContent = "대표"; ph.appendChild(tag); }
			photoBox.appendChild(ph);
		});
		preview();
	});

	// ---------- 글자 수 ----------
	const contents = $("contents");
	const count = () => ($("contentsCount").textContent = won(contents.value.length));
	contents.addEventListener("input", count);
	count();

	// ---------- 미리보기 카드 ----------
	function preview() {
		$("pvTitle").textContent = $("prod_title").value.trim() || "판매글 제목";
		$("pvCat").textContent = cnum.value === "0" ? (newCat.value.trim() || "새 카테고리") :
			(cnum.selectedIndex > 0 ? cnum.options[cnum.selectedIndex].text : "카테고리");
		$("pvPrice").textContent = $("start_amt").value ? won($("start_amt").value) + "원" : "0원";
		$("pvUnit").textContent = $("join_amt").value ? won($("join_amt").value) + "원" : "-";

		const s = parse(start.value), e = parse(end.value), now = new Date(), badge = $("pvBadge");
		const time = $("pvTime");
		if (s && e && e > s) {
			const status = now < s ? "ready" : now > e ? "ended" : "live";
			badge.className = "auct-badge auct-badge-" + status;
			badge.textContent = { ready: "시작 전", live: "진행 중", ended: "마감" }[status];
			const days = Math.max(1, Math.round((e - s) / 86400000));
			time.innerHTML = '<i class="bi bi-clock"></i>' + days + "일 경매";
		} else {
			badge.className = "auct-badge auct-badge-live";
			badge.textContent = "진행 중";
			time.innerHTML = '<i class="bi bi-clock"></i>기간 미정';
		}

		const first = fileInput.files && fileInput.files[0];
		const thumb = $("pvThumb");
		if (first) {
			let img = thumb.querySelector("img");
			if (!img) { thumb.querySelector(".auct-thumb-empty")?.remove(); img = document.createElement("img"); img.alt = ""; thumb.prepend(img); }
			img.src = photoBox.querySelector("img")?.src || URL.createObjectURL(first);
		}
	}
	["prod_title", "prod_name"].forEach((id) => $(id).addEventListener("input", preview));
	markChips();
	durationText();
	preview();

	// ---------- 전송 전 검사 ----------
	function setInvalid(el, bad) {
		el.classList.toggle("is-invalid", bad);
		const fb = el.closest(".col-md-6, .col-12, .mb-3, .col-md-7")?.querySelector(".invalid-feedback");
		if (fb) fb.style.display = bad ? "block" : "";
	}
	form.querySelectorAll("input, select, textarea").forEach((el) =>
		el.addEventListener("input", () => el.classList.contains("is-invalid") && setInvalid(el, false)));

	form.addEventListener("submit", (e) => {
		const errors = [];
		const check = (el, ok, msg) => { setInvalid(el, !ok); if (!ok) errors.push([el, msg]); };

		check($("prod_title"), $("prod_title").value.trim() !== "", "판매글 제목");
		check($("prod_name"), $("prod_name").value.trim() !== "", "상품명");
		check(cnum, cnum.value !== "" && (cnum.value !== "0" || newCat.value.trim() !== ""), "카테고리");
		check($("start_amt_input"), Number($("start_amt").value) > 0, "시작 가격");
		check($("join_amt_input"), Number($("join_amt").value) > 0, "입찰 단위");
		check($("total_cnt"), Number($("total_cnt").value) >= 1, "판매 수량");
		const s = parse(start.value), en = parse(end.value);
		check(start, !!s, "경매 시작");
		check(end, !!en && (!s || en > s), "경매 종료");
		if (limitSwitch.checked) {
			check(limitInput, Number($("limit_amt").value) > Number($("start_amt").value), "즉시구매가");
		}

		if (errors.length) {
			e.preventDefault();
			errors[0][0].scrollIntoView({ behavior: "smooth", block: "center" });
			errors[0][0].focus({ preventScroll: true });
			alert("입력 내용을 확인해주세요: " + errors.map((x) => x[1]).join(", "));
			return;
		}
		$("submitBtn").disabled = true; // 두 번 눌러서 같은 상품이 두 개 등록되지 않게
		$("submitBtn").innerHTML = '<span class="spinner-border spinner-border-sm"></span> 저장 중...';
	});

	// ---------- 주소 검색 (도로명주소 팝업 → jusoCallBack) ----------
	$("addrBtn").addEventListener("click", () => {
		window.open("/web/aucts/jusoPopup", "pop", "width=570,height=420,scrollbars=yes,resizable=yes");
	});
	window.jusoCallBack = (addr) => { $("roadFullAddr").value = addr; };
})();
