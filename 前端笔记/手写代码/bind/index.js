Object.prototype.myBind = function (self, ...args) {
  let that = this
  return (...newArgs) => {
    this.call(self, ...args, ...newArgs)
  }
}
let a = { a1: 1, b1: 2 }
global.a1 = '110'
function echo(a) {
  console.log(this.a1, a)
}
echo.bind(a, 123)(123)
echo(123)
echo.myBind(a, 123)(123)