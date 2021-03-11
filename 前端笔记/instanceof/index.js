// instanceof 检查right的prototype是否在left的原型链中
function myInstanceof(left, right) {
  let rightPrototype = right.prototype
  let getPrototype = function (obj) {
    return Object.getPrototypeOf(obj)
  }
  let leftPrototype = getPrototype(left)
  while (leftPrototype !== null) {
    if (leftPrototype === rightPrototype) {
      return true
    } else {
      leftPrototype = getPrototype(leftPrototype)
    }
  }
  return false
}
function a() {
  this.aa = 1
}
let obj1 = {}
let obj2 = new a()
console.log(obj1 instanceof a)
console.log(myInstanceof(obj1, a))
console.log('---------------------')
console.log(obj2 instanceof a)
console.log(myInstanceof(obj2, a))