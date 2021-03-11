function myNew(OB, ...args) {
  let obj = Object.create(OB.prototype)
  let res = OB.call(obj, ...args)
  if (!(res instanceof Object)) {
    return obj
  } else {
    return res
  }
}
function Echo(value) {
  this.a = value
}
Echo.prototype.echo = function () {
  console.log(this.a)
}
let obj = new Echo('1')
obj.echo()
let obj2 = myNew(Echo, '1')
obj2.echo()