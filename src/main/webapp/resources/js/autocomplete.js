/*
 * 검색창 자동완성
 *  - form.form-search 안의 input[name=value] 에 자동으로 붙는다 (메인, 전체 경매 화면)
 *  - 입력이 멈추고 0.2초 뒤에 /web/product-api/suggest 를 호출 (글자마다 요청하지 않도록)
 *  - ↑ ↓ 로 이동, Enter 로 선택 후 검색, Esc 로 닫기, 마우스 클릭으로도 선택
 *  - 추천어는 textContent 로만 넣어서 상품명에 HTML 이 있어도 실행되지 않음
 */
(function () {
	const URL = "/web/product-api/suggest?q=";
	const TYPE_LABEL = { PRODUCT: "상품", CATEGORY: "카테고리" };

	function attach(input) {
		const form = input.form;
		input.setAttribute("autocomplete", "off"); // 브라우저 기본 자동완성과 겹치지 않게

		const box = document.createElement("ul");
		box.className = "search-suggest";
		box.setAttribute("role", "listbox");
		box.hidden = true;
		form.classList.add("search-suggest-wrap");
		form.appendChild(box);

		let items = [];
		let active = -1;
		let timer = null;
		let lastQuery = "";
		let controller = null;

		function close() {
			box.hidden = true;
			active = -1;
		}

		function highlight(text, q) {
			// 검색어와 같은 부분만 <strong> 으로 감싸기 (모두 텍스트 노드로 만들어 안전)
			const frag = document.createDocumentFragment();
			const idx = text.toLowerCase().indexOf(q.toLowerCase());
			if (idx < 0 || q === "") {
				frag.appendChild(document.createTextNode(text));
				return frag;
			}
			frag.appendChild(document.createTextNode(text.slice(0, idx)));
			const strong = document.createElement("strong");
			strong.textContent = text.slice(idx, idx + q.length);
			frag.appendChild(strong);
			frag.appendChild(document.createTextNode(text.slice(idx + q.length)));
			return frag;
		}

		function render(list, q) {
			items = list;
			active = -1;
			box.innerHTML = "";
			if (list.length === 0) {
				// 결과가 없을 때도 알려줘야 '동작하지 않는 것' 처럼 보이지 않는다
				const li = document.createElement("li");
				li.className = "empty";
				li.textContent = "'" + q + "' 와 일치하는 상품이 없어요";
				box.appendChild(li);
				box.hidden = false;
				return;
			}
			list.forEach((item, i) => {
				const li = document.createElement("li");
				li.setAttribute("role", "option");

				const word = document.createElement("span");
				word.className = "suggest-word";
				word.appendChild(highlight(item.keyword, q));

				const meta = document.createElement("span");
				meta.className = "suggest-meta";
				meta.textContent = (TYPE_LABEL[item.type] || "") + " · " + item.cnt + "건";

				li.appendChild(word);
				li.appendChild(meta);
				// blur 보다 먼저 실행되도록 click 대신 mousedown
				li.addEventListener("mousedown", (e) => {
					e.preventDefault();
					choose(i);
				});
				box.appendChild(li);
			});
			box.hidden = false;
		}

		function setActive(i) {
			const lis = box.querySelectorAll("li");
			lis.forEach((li) => li.classList.remove("active"));
			active = i;
			if (i >= 0 && lis[i]) {
				lis[i].classList.add("active");
				lis[i].scrollIntoView({ block: "nearest" });
			}
		}

		function choose(i) {
			input.value = items[i].keyword;
			close();
			form.submit();
		}

		function request(q) {
			if (controller) controller.abort(); // 이전 요청이 늦게 도착해서 결과가 뒤섞이지 않게
			controller = new AbortController();
			fetch(URL + encodeURIComponent(q), { signal: controller.signal })
				.then((res) => (res.ok ? res.json() : []))
				.then((list) => {
					if (input.value.trim() === q) render(list, q);
				})
				.catch(() => { /* 취소되었거나 네트워크 오류 → 무시 */ });
		}

		// 한글 IME · 브라우저 조합에 따라 input 이벤트가 늦거나 안 올 수 있어서 keyup / compositionend 에서도 확인
		// (같은 검색어면 lastQuery 로 걸러지므로 요청이 중복되지 않는다)
		const onChange = () => {
			const q = input.value.trim();
			clearTimeout(timer);
			if (q === "") {
				lastQuery = "";
				close();
				return;
			}
			if (q === lastQuery) return;
			timer = setTimeout(() => {
				lastQuery = q;
				request(q);
			}, 200);
		};
		input.addEventListener("input", onChange);
		input.addEventListener("compositionend", onChange);
		input.addEventListener("keyup", (e) => {
			if (!["ArrowDown", "ArrowUp", "Enter", "Escape"].includes(e.key)) onChange();
		});

		input.addEventListener("keydown", (e) => {
			if (box.hidden || items.length === 0) return;
			if (e.key === "ArrowDown") {
				e.preventDefault();
				setActive((active + 1) % items.length);
			} else if (e.key === "ArrowUp") {
				e.preventDefault();
				setActive(active <= 0 ? items.length - 1 : active - 1);
			} else if (e.key === "Enter" && active >= 0) {
				e.preventDefault();
				choose(active);
			} else if (e.key === "Escape") {
				close();
			}
		});

		input.addEventListener("blur", close);
		input.addEventListener("focus", () => {
			if (items.length > 0 && input.value.trim() === lastQuery) box.hidden = false;
		});
	}

	function init() {
		document.querySelectorAll('form.form-search input[name="value"]').forEach(attach);
	}
	// 스크립트가 늦게 실행돼 DOMContentLoaded 가 이미 지나간 경우에도 붙도록
	if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", init);
	else init();
})();
