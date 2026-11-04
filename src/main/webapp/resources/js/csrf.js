/*
 * CSRF 토큰 자동 첨부 (서버: com.myauct.web.global.CsrfFilter)
 *  - <meta name="csrf-token"> 의 값을
 *    · fetch 의 POST/PUT/DELETE 요청에 X-CSRF-TOKEN 헤더로
 *    · jQuery $.ajax 요청에 같은 헤더로
 *    · method="post" 폼에 hidden 칸(_csrf)으로 붙인다
 *  - <head> 에서 다른 스크립트보다 먼저 불러야 한다
 */
(function () {
	const meta = document.querySelector('meta[name="csrf-token"]');
	const token = meta ? meta.getAttribute("content") : "";
	if (!token) return;
	const SAFE = ["GET", "HEAD", "OPTIONS"];
	const sameOrigin = (url) => {
		try { return new URL(url, location.href).origin === location.origin; } catch (e) { return false; }
	};

	// fetch
	const originalFetch = window.fetch;
	window.fetch = function (input, init) {
		init = init || {};
		const method = (init.method || (input instanceof Request ? input.method : "GET")).toUpperCase();
		const url = input instanceof Request ? input.url : String(input);
		if (!SAFE.includes(method) && sameOrigin(url)) {
			const headers = new Headers(init.headers || (input instanceof Request ? input.headers : undefined));
			headers.set("X-CSRF-TOKEN", token);
			init = Object.assign({}, init, { headers: headers });
		}
		return originalFetch.call(this, input, init);
	};

	function addToForm(form) {
		if ((form.getAttribute("method") || "get").toLowerCase() !== "post") return;
		if (!sameOrigin(form.action || location.href)) return;
		let input = form.querySelector('input[name="_csrf"]');
		if (!input) {
			input = document.createElement("input");
			input.type = "hidden";
			input.name = "_csrf";
			form.appendChild(input);
		}
		input.value = token;
	}

	// 폼: 화면이 그려진 뒤 모두에 붙이고 (form.submit() 으로 보내는 경우 대비), 나중에 생긴 폼은 전송할 때 붙인다
	document.addEventListener("submit", (e) => addToForm(e.target), true);
	function onReady() {
		document.querySelectorAll("form").forEach(addToForm);
		// jQuery 는 보통 이 파일보다 늦게 불러오므로 준비된 뒤에 설정
		if (window.jQuery) {
			window.jQuery.ajaxSetup({
				beforeSend: function (xhr, settings) {
					if (!SAFE.includes((settings.type || "GET").toUpperCase()) && sameOrigin(settings.url)) {
						xhr.setRequestHeader("X-CSRF-TOKEN", token);
					}
				},
			});
		}
	}
	if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", onReady);
	else onReady();
})();
