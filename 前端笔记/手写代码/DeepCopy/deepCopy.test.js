import isEqual from "lodash.isequal";
import deepCopy from "./deepCopy.js";
let a = { a: 1230, b: 123 };
let ad = deepCopy(a);
let b = { a: "46", b: { c: 1253, d: { ee: 1234 } } };
let bd = deepCopy(b);
let c = { a: 123 };
c.b = c;
let cd = deepCopy(c);
test("测试单层对象拷贝", () => {
  expect(isEqual(a, ad)).toBe(true);
});
test("测试多层对象拷贝", () => {
  expect(isEqual(b, bd)).toBe(true);
});
test("循环引用对象拷贝", () => {
  expect(isEqual(c, cd)).toBe(true);
});
test("判断单层对象拷贝是否生效", () => {
  ad.a = 111;
  expect(isEqual(a, ad)).toBe(false);
});
test("判断多层对象拷贝是否生效", () => {
  bd.b.c = 111;
  expect(isEqual(a, bd)).toBe(false);
});
test("判断引用对象拷贝是否生效", () => {
  cd.b.a = 111;
  expect(isEqual(a, cd)).toBe(false);
});
