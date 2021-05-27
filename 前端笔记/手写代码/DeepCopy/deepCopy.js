function deepCopy(obj) {
  let circularArr = [];
  let func = (obj) => {
    // 处理循环引用
    if (circularArr.includes(obj)) {
      return obj;
    } else {
      circularArr.push(obj);
    }
    let res = Array.isArray(obj) ? [] : {};
    for (let key in obj) {
      if (obj.hasOwnProperty(key)) {
        if (typeof obj[key] === "object") {
          res[key] = func(obj[key]);
        } else {
          res[key] = obj[key];
        }
      }
    }
    return res;
  };
  return func(obj);
}

export default deepCopy;
