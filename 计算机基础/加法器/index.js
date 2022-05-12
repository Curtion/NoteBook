console.log(add(54, 320));
function add(a, b) {
  if (b == 0) {
    return a;
  }
  const xor = a ^ b;
  const conj = (a & b) << 1;
  return add(xor, conj);
}

// 本质上是模拟了一个全加法器
