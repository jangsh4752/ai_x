/* while(조건) {
    반복할 명령어들;
}

do { - 무조건 1번 실행 후 조건 따짐
    반복할 명령어들;
}while(조건);
1초 동안 while문을 몇번 실행했는지 출력
*/
var now = new Date();
var startTime = now.getTime();
// console.log(startTime);
var cnt = 0;
while(new Date().getTime() < startTime+1000) {
    cnt++; // cnt 1 증가
}
console.log('while문 반복 횟수 : ', cnt);

startTime = new Date().getTime();
cnt=0;
do{
    ++cnt;
}while(new Date().getTime() < startTime+1000);
console.log('do~while문 반복 횟수 : ', cnt);