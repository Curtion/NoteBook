import isEqual from "./isEqual.js";
import deepCopy from "./deepCopy.js";
const a = { a: 1230, b: 123 };
const b = { a: "46", b: { c: 1253, d: { ee: 1234 } } };

test("测试单层对象拷贝", () => {
  expect(isEqual(a, deepCopy(a))).toBe(true);
});
test("测试多层对象拷贝", () => {
  expect(isEqual(b, deepCopy(b))).toBe(true);
});
