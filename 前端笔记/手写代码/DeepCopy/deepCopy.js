function deepCopy(obj) {
  let res = {};
  let func = (obj, res) => {
    for (let key in obj) {
      if (obj.hasOwnProperty(key)) {
        if (typeof obj[key] === "object") {
          if (Array.isArray(obj[key])) {
          } else {
            func(obj[key], res[key]);
          }
        } else {
          res[key] = obj[key];
        }
      }
    }
  };
  func(obj, res);
  return res;
}
const b = { a: "46", b: { c: 1253, d: { ee: 1234 } } };
console.log(deepCopy(b));
export default deepCopy;
