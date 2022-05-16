# 窥探现代浏览器架构系列(翻译)

 - [窥探现代浏览器架构(一)](https://zhuanlan.zhihu.com/p/99394757)
 - [窥探现代浏览器架构(二)](https://zhuanlan.zhihu.com/p/99668141)
 - [窥探现代浏览器架构(三)](https://zhuanlan.zhihu.com/p/101587249)
 - [窥探现代浏览器架构(四)](https://zhuanlan.zhihu.com/p/102137317)

# 窥探现代浏览器架构系列(原文)

 - [Inside look at modern web browser(一)](https://developer.chrome.com/blog/inside-browser-part1/)
 - [Inside look at modern web browser(二)](https://developer.chrome.com/blog/inside-browser-part2/)
 - [Inside look at modern web browser(三)](https://developer.chrome.com/blog/inside-browser-part3/)
 - [Inside look at modern web browser(四)](https://developer.chrome.com/blog/inside-browser-part4/)

# 疑问

在正常情况下UI线程和JS线程是互斥的状态，如果JS代码处于死循环状态，那么界面中的GIF动图应该会停止渲染才对。

为此我写了`index.html`代码，在`FireFox`浏览器内现象和我想象的相同，但是在`Chromium`浏览器(`Edge 100+`)中GIF动图依然会正常渲染。
