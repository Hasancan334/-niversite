// node test.js
const assert = require("assert");
const { kisalt } = require("./yardimci");

assert.strictEqual(kisalt("a  b\nc", 10), "a b c");
assert.strictEqual(kisalt("abcdef", 4), "abc…");
assert.strictEqual(kisalt(undefined, 4), "");
console.log("Tüm testler geçti");
