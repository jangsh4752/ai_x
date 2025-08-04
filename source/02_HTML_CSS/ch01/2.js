// 2.js
/* 동적인 부분 */
var name = prompt("이름은?", "홍길동"); // 취소 클릭 시 'null' return]
if (name != 'null' && name != '') { // prompt 입력 후 확인 클릭 시
    document.write(name + '님 반갑습니다.<br>');
}
