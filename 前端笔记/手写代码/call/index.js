Object.prototype.myCall = function (context, ...arg) {
  context.func = this
  let res = context.func(...arg)
  delete context.func
  return res
}
let a = {
  aa: 1,
  bb: 2
}
global.aa = 'ok'
function echo(arg) {
  console.log(this.aa, arg)
}
echo('hello')
echo.call(a, 'hello')
echo.myCall(a, 'hello')
