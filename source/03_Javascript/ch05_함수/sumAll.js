function sumAll() {
    // 매개변수가 없으면 -999 return
    // 매개변수가 있으면 매개변수들의 합을 return
    let sum = 0;
    if(arguments.length==0){
        return -999;
    }
    else{
        for(i=0;i<arguments.length;i++) {
            sum += arguments[i];
        }
        return sum;
    }
}
// test
// console.log(sumAll());
// console.log(sumAll(1,2));
// console.log(sumAll(1,2,3,4,5));