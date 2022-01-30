function curry(func) {
    return function curried(...args) {
        if (args.length >= func.length) {
            return func.apply(this, args);
        } else {
            return function(...args2) {
                return curried.apply(this, args.concat(args2));
            }
        }
    };
}
  
// usage
function sum(a, b) {
    return a + b;
}
  
let curriedSum = curry(sum);

let curriedSum1 = curriedSum(1);

console.log( curriedSum1(2) ); // 3
