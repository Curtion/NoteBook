Object.prototype.myApply = function (that, args) {
  that.func = this
  let res = null
  if (args) {
    res = that.func(...args)
  } else {
    res = that.func()
  }
  delete that.func
  return res
}
let a = {
  a: 1,
  b: 2
}
global.a = 'ok'
function echo(...args) {
  console.log(this.a, args)
}
echo('x', 'y', 'z')
echo.apply(a, ['x', 'y', 'z'])
echo.myApply(a, ['x', 'y', 'z'])
echo.myApply(a)