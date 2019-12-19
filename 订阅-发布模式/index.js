/*
 * 实现一个类可以完成事件 on, once, trigger, off
 * @Author: Curtion
 * @Date: 2019-12-19 21:33:37
 * @Last Modified by: Curtion
 * @Last Modified time: 2019-12-19 22:20:37
*/
class EventEmitter {
  constructor() {
    this.listeners = {}
  }
  on(type, fn) {
    if (this.listeners.hasOwnProperty(type)) {
      this.listeners[type].push(fn)
    } else {
      this.listeners[type] = [fn]
    }
  }
  trigger(type) {
    if (this.listeners.hasOwnProperty(type)) {
      this.listeners[type].forEach(element => {
        element()
      })
    }
  }
  once(type, fn) {
    this.on(type, () => {
      fn()
      this.off(type)
    })
  }
  off(type) {
    delete this.listeners[type]
  }
}
const event = new EventEmitter()
event.on('one', () => {
  console.log('one trigger-1')
})
event.trigger('one') // one trigger-1

event.on('one', () => {
  console.log('one trigger-2')
})
event.trigger('one') // one trigger-1  one trigger-2
event.off('one')
event.trigger('one') // 无输出

event.once('three', () => {
  console.log('three trigger')
})
event.trigger('three') // three trigger
event.trigger('three') // 无输出
