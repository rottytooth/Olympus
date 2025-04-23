const printBot = (n) => {
	console.write(n.asString() + beerStr.asString() + ` on the wall!\n`);
}
const check_ninetynine = (x) => {
	printBot(x);
}
const printBeerInsideLoop = (n) => {
	console.write(n.asString() + beerString.asString() + ` on the wall`+ n.asString() + beerString.asString() + `.\nTake one down, pass it around, `);
}
const printBeerOutsideLoop = (n) => {
	console.write(`No more bottles of beer on the wall!\nNo more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.`);
}
const beerLoop = (x) => {
	check_ninetynine(x);
	printBeerInsideLoop(x);
}
let beerString;
beerString = `bottles of beer`;
if (n < 99) {
	check_ninetynine(n);
}
let noMoreBeerString;
noMoreBeerString = `no more bottles of beer`;
for (let beerLoop_counter = 99; beerLoop_counter > 1; beerLoop_counter--) {
	beerLoop();
}
printBeerOutsideLoop();
