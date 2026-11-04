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

		grid.addEventListener("click", (e) => {
			const btn = e.target.closest(".auct-like");
			if (!btn) return;
			e.preventDefault();
			const on = !btn.classList.contains("on");
			btn.classList.toggle("on", on);
			btn.classList.remove("pop");
			void btn.offsetWidth; // 애니메이션 다시 시작
			btn.classList.add("pop");
			fetch("/web/product-api/" + (on ? "product_concern" : "product_unconcern"), {
				method: on ? "POST" : "DELETE",
				headers: json,
				body: JSON.stringify({ anum: Number(btn.dataset.anum) }),
			}).then((res) => {
				if (!res.ok) btn.classList.toggle("on", !on); // 실패하면 되돌림
			}).catch(() => btn.classList.toggle("on", !on));
		});
	});
})();
