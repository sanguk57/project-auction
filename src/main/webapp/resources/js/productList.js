/*
 * 상품 목록 (include/productGrid.jsp) 동작
 *  - 한 페이지 개수 변경
 *  - 찜(하트) 표시 / 추가 / 삭제  (회원번호는 서버가 세션에서 꺼냄)
 */
(function () {
	document.addEventListener("DOMContentLoaded", () => {
		const sel = document.getElementById("cntPerPage");
		if (sel) {
			sel.addEventListener("change", () => {
				// 검색어를 JSP 로 직접 찍으면 스크립트 삽입(XSS) 위험 → 현재 주소의 값을 그대로 사용
				const params = new URLSearchParams(location.search);
				params.set("cntPerPage", sel.value);
				params.set("nowPage", 1);
				location.href = location.pathname + "?" + params.toString();
			});
		}

		const grid = document.getElementById("productGrid");
		if (!grid || grid.dataset.login !== "true") return;

		const json = { "Content-Type": "application/json; charset=UTF-8" };

		// 내가 찜한 상품에 하트 채우기
		fetch("/web/product-api/concern_list", { method: "POST", headers: json, body: "{}" })
			.then((res) => (res.ok ? res.json() : []))
			.then((anums) => {
				grid.querySelectorAll(".auct-like").forEach((btn) => {
					if (anums.includes(Number(btn.dataset.anum))) btn.classList.add("on");
				});
			})
			.catch(() => {});

		// 숫자 표시 늘리기/줄이기 (예전: 하트를 눌러도 새로고침해야 "관심 상품 N" 이 바뀌었음)
		function bump(el, diff, suffix) {
			if (!el) return;
			const n = Math.max(0, (parseInt(el.textContent.replace(/[^\d]/g, ""), 10) || 0) + diff);
			el.textContent = n + (suffix || "");
		}
		const isConcernList = grid.dataset.key === "B";

		grid.addEventListener("click", (e) => {
			const btn = e.target.closest(".auct-like");
			if (!btn) return;
			e.preventDefault();
			if (btn.dataset.busy) return; // 빠르게 여러 번 눌러도 요청은 하나씩
			btn.dataset.busy = "1";

			const on = !btn.classList.contains("on");
			btn.classList.toggle("on", on);
			btn.classList.remove("pop");
			void btn.offsetWidth; // 애니메이션 다시 시작
			btn.classList.add("pop");

			fetch("/web/product-api/" + (on ? "product_concern" : "product_unconcern"), {
				method: on ? "POST" : "DELETE",
				headers: json,
				body: JSON.stringify({ anum: Number(btn.dataset.anum) }),
			})
				.then((res) => {
					if (!res.ok) throw new Error();
					bump(document.getElementById("concernCount"), on ? 1 : -1);
					// "관심 상품" 목록에서 하트를 끄면 카드를 목록에서 뺀다
					if (isConcernList && !on) {
						const col = btn.closest(".auct-card").parentElement;
						col.style.transition = "opacity .25s, transform .25s";
						col.style.opacity = "0";
						col.style.transform = "scale(.96)";
						setTimeout(() => col.remove(), 250);
						bump(document.getElementById("listCount"), -1, "건");
					}
				})
				.catch(() => btn.classList.toggle("on", !on)) // 실패하면 되돌림
				.finally(() => delete btn.dataset.busy);
		});
	});
})();
