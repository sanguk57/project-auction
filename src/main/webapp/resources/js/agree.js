const btn1 = document.querySelectorAll('.btn1')
const btnAll = document.querySelector('.btnAll')
const btn_ok = document.querySelectorAll('.btn_ok')
const ok_chk = document.querySelector('.ok_chk')


// 전체동의 버튼 클릭시 동작 
btnAll.addEventListener("click", (chk)=>{
    let sw = false;
    
    let chk_st = chk.target.checked
    if(chk_st){
        btn1.forEach((e)=>{
            e.checked = true;
        })
        sw = true
    }
    else{
        btn1.forEach((e)=>{
            e.checked = false;
        })
    }
});

const cntLength1 = btn1.length
var cnt = 0
function checkedCnt() {
    btn1.forEach((item)=>{
            if(item.checked){
                cnt++
            }
        })
    // 4개의 버튼 전체 체크시 전체동의 버튼 체크 
    if(cnt === cntLength1)
    btnAll.checked = true
    else btnAll.checked = false
}

btn1.forEach((x)=>{
    x.addEventListener("click", ()=>{
        cnt=0
        checkedCnt()
    })
})
const cntLength2 = btn_ok.length
var cnt1=0
function checkedOk (e) {
    btn_ok.forEach((item)=>{
        if(item.checked){
            cnt1++
        }
    })
    // 2개의 필수동의 체크 카운트 
    if(!(cnt1===cntLength2)){
        e.preventDefault();
        alert("필수동의 사항 체크해주세요.")
    }
}
ok_chk.addEventListener("click", (e)=>{
    cnt1=0
    checkedOk(e)
})


const w = screen.width
const h = screen.height
const container = document.querySelector(".container")
container.style.width= w+"px"
container.style.height= h+"px"
