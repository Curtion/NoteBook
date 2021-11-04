// 描述: 手里有一组数字卡片，每个人说出自己想要的一组数字(只能领到一张想要的卡片)。要判断手里的卡片是否能按大家需要分配每一个人。
function main(desire, gift) {
  const path = [];
  let status = false;
  const map = {};
  for (let item of gift) {
    if (map[item]) {
      map[item] = map[item] + 1;
    } else {
      map[item] = 1;
    }
  }
  const dfs = (index) => {
    if (status) {
      return;
    }
    if (index > desire.length - 1) {
      console.log("递归完成:", path);
      const nmap = { ...map };
      for (let i = 0; i < path.length; i++) {
        if (nmap[path[i]] && nmap[path[i]] > 0) {
          nmap[path[i]] = nmap[path[i]] - 1;
        } else {
          return;
        }
      }
      status = true;
      return;
    }
    for (let item of desire[index]) {
      path.push(item);
      console.log("递归前:", path);
      index++;
      dfs(index);
      path.pop();
      index--;
      console.log("递归后:", path);
    }
  };
  dfs(0);
  return status;
}
console.log(main([[1, 2], [1, 3, 4], [3]], [1, 3, 3]));
