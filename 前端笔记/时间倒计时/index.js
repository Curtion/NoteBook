/*
 * 发布新闻时需要提醒发布的时间。写一个函数，传递一个参数为时间戳，完成时间的格式化。
 * 如果发布一分钟内，输出：刚刚；
 * n 分钟前发布，输出：n分钟前；
 * 超过一个小时，输出：n小时前；
 * 超过一天，输出：n天前；
 * 但超过一个星期，输出发布的准确时间
 * @Author: Curtion
 * @Date: 2019-12-19 22:23:08
 * @Last Modified by: Curtion
 * @Last Modified time: 2019-12-19 23:50:40
*/
function dayFormat(timer) {
  if (typeof timer === 'number') {
    time = new Date().getTime() - timer
    if (time < 1000 * 60) {
      return '刚刚'
    } else if (time >= 1000 * 60 && time < 1000 * 60 * 60) {
      return `${Math.floor(time / (1000 * 60))}分钟前`
    } else if (time >= 1000 * 60 * 60 && time < 1000 * 60 * 60 * 24) {
      return `${Math.floor(time / (1000 * 60 * 60))}小时前`
    } else if (time >= 1000 * 60 * 60 * 24 && time < 1000 * 60 * 60 * 24 * 7) {
      return `${Math.floor(time / (1000 * 60 * 60 * 24))}天前`
    } else {
      return new Date(timer)
    }
  }

}
console.log(dayFormat(1575945955000))