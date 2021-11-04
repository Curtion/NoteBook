// 描述: 手里有一组数字卡片，每个人说出自己想要的一组数字(只能领到一张想要的卡片)。要判断手里的卡片是否能按大家需要分配每一个人。
function main(desire, gift) {
  const combina = (arr1, arr2) => {
    let arr = [];
    for (let v1 of arr1) {
      for (let v2 of arr2) {
        arr.push(`${v1}${v2}`);
      }
    }
    return arr;
  };
  const generate = (arr, length) => {
    if (length <= 2) {
      return combina(arr[length - 2], arr[length - 1]);
    }
    return combina(generate(arr, length - 1), arr[length - 1]);
  };
  const fullArr = generate(desire, desire.length);
  return fullArr.some((item) => {
    const ngift = [...gift];
    const length = item.split("").length;
    for (let i = 0; i < length; i++) {
      const index = ngift.indexOf(Number(item[i]));
      if (index === -1) break;
      ngift.splice(index, 1);
      if (i === length - 1) {
        return true;
      }
    }
    return false;
  });
}
console.log(main([[1, 2], [1, 3], [3]], [1, 3, 4]));
// 此题复杂度是O(n^n)，大问题
