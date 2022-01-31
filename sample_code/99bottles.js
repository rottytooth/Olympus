const printBot = (n) => {
	console.log(n);
	console.log(beerStr);
	console.log("%20on%20the%20wall%21%0A");
}
const check99 = (x) => {
	printBot(x);
}
let beerString;
beerString = "bottles%20of%20beer";
if ((n < 99)) {
	check99(n);
}
let noMoreBeerString;
noMoreBeerString = "no%20more%20bottles%20of%20beer";
const printBeerInsideLoop = (n) => {
	console.log(n);
	console.log(beerString);
	console.log("%20on%20the%20wall");
	console.log(n);
	console.log(beerString);
	console.log(".%0ATake%20one%20down%2C%20pass%20it%20around%2C%20");
}
const printBeerOutsideLoop = (n) => {
console.log("No%20more%20bottles%20of%20beer%20on%20the%20wall%21%0ANo%20more%20bottles%20of%20beer%20on%20the%20wall%2C%20no%20more%20bottles%20of%20beer.%0AGo%20to%20the%20store%20and%20buy%20some%20more%2C%2099%20bottles%20of%20beer%20on%20the%20wall.");
}
const beerLoop = (x) => {
	check99(x);
}

