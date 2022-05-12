# 说明

Babel 新版有多种配置方式，在此记录配置结果，下述配置都是在 `babel.config.json`中。
不考虑`"@babel/polyfill"`和corejs2版本，因为它们已经被弃用。

# 测试代码

``` javascript
const c = 1;
function test() {
  new Promise();
}
test();
class a {}


```

# 配置一
配置：
```json
{
  "presets": [
    [
      "@babel/preset-env"
    ]
  ]
}
```

输出：
```javascript
"use strict";

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var c = 1;

function test() {
  new Promise();
}

test();

var a = /*#__PURE__*/_createClass(function a() {
  _classCallCheck(this, a);
});
```

配置`@babel/preset-env`预设
不配置`useBuiltIns`字段(默认为`false`)
不配置`@babel/plugin-transform-runtime`插件。
此时只进行了语法转化，没有对API进行转化支持。(对`const`和`class`在语法上进行了转化，但没有对`Promise`进行转换)

# 配置二

配置：
```json
{
  "presets": [
    [
      "@babel/preset-env",
      {
        "targets": "> 0.25%, not dead",
        "useBuiltIns": "entry",
        "corejs": 3
      }
    ]
  ]
}
```

此时需要在测试代码顶部加入`import "core-js"`

输出：
```javascript
"use strict";

require("core-js/modules/es.symbol.js");

require("core-js/modules/es.symbol.description.js");

require("core-js/modules/es.symbol.async-iterator.js");

require("core-js/modules/es.symbol.has-instance.js");

require("core-js/modules/es.symbol.is-concat-spreadable.js");

require("core-js/modules/es.symbol.iterator.js");

require("core-js/modules/es.symbol.match.js");

require("core-js/modules/es.symbol.replace.js");

require("core-js/modules/es.symbol.search.js");

require("core-js/modules/es.symbol.species.js");

require("core-js/modules/es.symbol.split.js");

require("core-js/modules/es.symbol.to-primitive.js");

require("core-js/modules/es.symbol.to-string-tag.js");

require("core-js/modules/es.symbol.unscopables.js");

require("core-js/modules/es.array.concat.js");

require("core-js/modules/es.array.copy-within.js");

require("core-js/modules/es.array.fill.js");

require("core-js/modules/es.array.filter.js");

require("core-js/modules/es.array.find.js");

require("core-js/modules/es.array.find-index.js");

require("core-js/modules/es.array.flat.js");

require("core-js/modules/es.array.flat-map.js");

require("core-js/modules/es.array.from.js");

require("core-js/modules/es.array.includes.js");

require("core-js/modules/es.array.index-of.js");

require("core-js/modules/es.array.iterator.js");

require("core-js/modules/es.array.join.js");

require("core-js/modules/es.array.last-index-of.js");

require("core-js/modules/es.array.map.js");

require("core-js/modules/es.array.of.js");

require("core-js/modules/es.array.reduce.js");

require("core-js/modules/es.array.reduce-right.js");

require("core-js/modules/es.array.slice.js");

require("core-js/modules/es.array.sort.js");

require("core-js/modules/es.array.species.js");

require("core-js/modules/es.array.splice.js");

require("core-js/modules/es.array.unscopables.flat.js");

require("core-js/modules/es.array.unscopables.flat-map.js");

require("core-js/modules/es.array-buffer.constructor.js");

require("core-js/modules/es.date.to-primitive.js");

require("core-js/modules/es.function.has-instance.js");

require("core-js/modules/es.function.name.js");

require("core-js/modules/es.json.to-string-tag.js");

require("core-js/modules/es.map.js");

require("core-js/modules/es.math.acosh.js");

require("core-js/modules/es.math.asinh.js");

require("core-js/modules/es.math.atanh.js");

require("core-js/modules/es.math.cbrt.js");

require("core-js/modules/es.math.clz32.js");

require("core-js/modules/es.math.cosh.js");

require("core-js/modules/es.math.expm1.js");

require("core-js/modules/es.math.fround.js");

require("core-js/modules/es.math.hypot.js");

require("core-js/modules/es.math.imul.js");

require("core-js/modules/es.math.log10.js");

require("core-js/modules/es.math.log1p.js");

require("core-js/modules/es.math.log2.js");

require("core-js/modules/es.math.sign.js");

require("core-js/modules/es.math.sinh.js");

require("core-js/modules/es.math.tanh.js");

require("core-js/modules/es.math.to-string-tag.js");

require("core-js/modules/es.math.trunc.js");

require("core-js/modules/es.number.constructor.js");

require("core-js/modules/es.number.epsilon.js");

require("core-js/modules/es.number.is-finite.js");

require("core-js/modules/es.number.is-integer.js");

require("core-js/modules/es.number.is-nan.js");

require("core-js/modules/es.number.is-safe-integer.js");

require("core-js/modules/es.number.max-safe-integer.js");

require("core-js/modules/es.number.min-safe-integer.js");

require("core-js/modules/es.number.parse-float.js");

require("core-js/modules/es.number.parse-int.js");

require("core-js/modules/es.number.to-fixed.js");

require("core-js/modules/es.object.assign.js");

require("core-js/modules/es.object.define-getter.js");

require("core-js/modules/es.object.define-properties.js");

require("core-js/modules/es.object.define-property.js");

require("core-js/modules/es.object.define-setter.js");

require("core-js/modules/es.object.entries.js");

require("core-js/modules/es.object.freeze.js");

require("core-js/modules/es.object.from-entries.js");

require("core-js/modules/es.object.get-own-property-descriptor.js");

require("core-js/modules/es.object.get-own-property-descriptors.js");

require("core-js/modules/es.object.get-own-property-names.js");

require("core-js/modules/es.object.get-prototype-of.js");

require("core-js/modules/es.object.is.js");

require("core-js/modules/es.object.is-extensible.js");

require("core-js/modules/es.object.is-frozen.js");

require("core-js/modules/es.object.is-sealed.js");

require("core-js/modules/es.object.keys.js");

require("core-js/modules/es.object.lookup-getter.js");

require("core-js/modules/es.object.lookup-setter.js");

require("core-js/modules/es.object.prevent-extensions.js");

require("core-js/modules/es.object.seal.js");

require("core-js/modules/es.object.set-prototype-of.js");

require("core-js/modules/es.object.to-string.js");

require("core-js/modules/es.object.values.js");

require("core-js/modules/es.parse-float.js");

require("core-js/modules/es.parse-int.js");

require("core-js/modules/es.promise.js");

require("core-js/modules/es.promise.finally.js");

require("core-js/modules/es.reflect.apply.js");

require("core-js/modules/es.reflect.construct.js");

require("core-js/modules/es.reflect.define-property.js");

require("core-js/modules/es.reflect.delete-property.js");

require("core-js/modules/es.reflect.get.js");

require("core-js/modules/es.reflect.get-own-property-descriptor.js");

require("core-js/modules/es.reflect.get-prototype-of.js");

require("core-js/modules/es.reflect.has.js");

require("core-js/modules/es.reflect.is-extensible.js");

require("core-js/modules/es.reflect.own-keys.js");

require("core-js/modules/es.reflect.prevent-extensions.js");

require("core-js/modules/es.reflect.set.js");

require("core-js/modules/es.reflect.set-prototype-of.js");

require("core-js/modules/es.regexp.constructor.js");

require("core-js/modules/es.regexp.exec.js");

require("core-js/modules/es.regexp.flags.js");

require("core-js/modules/es.regexp.to-string.js");

require("core-js/modules/es.set.js");

require("core-js/modules/es.string.code-point-at.js");

require("core-js/modules/es.string.ends-with.js");

require("core-js/modules/es.string.from-code-point.js");

require("core-js/modules/es.string.includes.js");

require("core-js/modules/es.string.iterator.js");

require("core-js/modules/es.string.match.js");

require("core-js/modules/es.string.pad-end.js");

require("core-js/modules/es.string.pad-start.js");

require("core-js/modules/es.string.raw.js");

require("core-js/modules/es.string.repeat.js");

require("core-js/modules/es.string.replace.js");

require("core-js/modules/es.string.search.js");

require("core-js/modules/es.string.split.js");

require("core-js/modules/es.string.starts-with.js");

require("core-js/modules/es.string.trim.js");

require("core-js/modules/es.string.trim-end.js");

require("core-js/modules/es.string.trim-start.js");

require("core-js/modules/es.string.anchor.js");

require("core-js/modules/es.string.big.js");

require("core-js/modules/es.string.blink.js");

require("core-js/modules/es.string.bold.js");

require("core-js/modules/es.string.fixed.js");

require("core-js/modules/es.string.fontcolor.js");

require("core-js/modules/es.string.fontsize.js");

require("core-js/modules/es.string.italics.js");

require("core-js/modules/es.string.link.js");

require("core-js/modules/es.string.small.js");

require("core-js/modules/es.string.strike.js");

require("core-js/modules/es.string.sub.js");

require("core-js/modules/es.string.sup.js");

require("core-js/modules/es.typed-array.float32-array.js");

require("core-js/modules/es.typed-array.float64-array.js");

require("core-js/modules/es.typed-array.int8-array.js");

require("core-js/modules/es.typed-array.int16-array.js");

require("core-js/modules/es.typed-array.int32-array.js");

require("core-js/modules/es.typed-array.uint8-array.js");

require("core-js/modules/es.typed-array.uint8-clamped-array.js");

require("core-js/modules/es.typed-array.uint16-array.js");

require("core-js/modules/es.typed-array.uint32-array.js");

require("core-js/modules/es.typed-array.copy-within.js");

require("core-js/modules/es.typed-array.every.js");

require("core-js/modules/es.typed-array.fill.js");

require("core-js/modules/es.typed-array.filter.js");

require("core-js/modules/es.typed-array.find.js");

require("core-js/modules/es.typed-array.find-index.js");

require("core-js/modules/es.typed-array.for-each.js");

require("core-js/modules/es.typed-array.from.js");

require("core-js/modules/es.typed-array.includes.js");

require("core-js/modules/es.typed-array.index-of.js");

require("core-js/modules/es.typed-array.iterator.js");

require("core-js/modules/es.typed-array.join.js");

require("core-js/modules/es.typed-array.last-index-of.js");

require("core-js/modules/es.typed-array.map.js");

require("core-js/modules/es.typed-array.of.js");

require("core-js/modules/es.typed-array.reduce.js");

require("core-js/modules/es.typed-array.reduce-right.js");

require("core-js/modules/es.typed-array.reverse.js");

require("core-js/modules/es.typed-array.set.js");

require("core-js/modules/es.typed-array.slice.js");

require("core-js/modules/es.typed-array.some.js");

require("core-js/modules/es.typed-array.sort.js");

require("core-js/modules/es.typed-array.subarray.js");

require("core-js/modules/es.typed-array.to-locale-string.js");

require("core-js/modules/es.typed-array.to-string.js");

require("core-js/modules/es.weak-map.js");

require("core-js/modules/es.weak-set.js");

require("core-js/modules/esnext.aggregate-error.js");

require("core-js/modules/esnext.array.last-index.js");

require("core-js/modules/esnext.array.last-item.js");

require("core-js/modules/esnext.composite-key.js");

require("core-js/modules/esnext.composite-symbol.js");

require("core-js/modules/esnext.global-this.js");

require("core-js/modules/esnext.map.delete-all.js");

require("core-js/modules/esnext.map.every.js");

require("core-js/modules/esnext.map.filter.js");

require("core-js/modules/esnext.map.find.js");

require("core-js/modules/esnext.map.find-key.js");

require("core-js/modules/esnext.map.from.js");

require("core-js/modules/esnext.map.group-by.js");

require("core-js/modules/esnext.map.includes.js");

require("core-js/modules/esnext.map.key-by.js");

require("core-js/modules/esnext.map.key-of.js");

require("core-js/modules/esnext.map.map-keys.js");

require("core-js/modules/esnext.map.map-values.js");

require("core-js/modules/esnext.map.merge.js");

require("core-js/modules/esnext.map.of.js");

require("core-js/modules/esnext.map.reduce.js");

require("core-js/modules/esnext.map.some.js");

require("core-js/modules/esnext.map.update.js");

require("core-js/modules/esnext.math.clamp.js");

require("core-js/modules/esnext.math.deg-per-rad.js");

require("core-js/modules/esnext.math.degrees.js");

require("core-js/modules/esnext.math.fscale.js");

require("core-js/modules/esnext.math.iaddh.js");

require("core-js/modules/esnext.math.imulh.js");

require("core-js/modules/esnext.math.isubh.js");

require("core-js/modules/esnext.math.rad-per-deg.js");

require("core-js/modules/esnext.math.radians.js");

require("core-js/modules/esnext.math.scale.js");

require("core-js/modules/esnext.math.seeded-prng.js");

require("core-js/modules/esnext.math.signbit.js");

require("core-js/modules/esnext.math.umulh.js");

require("core-js/modules/esnext.number.from-string.js");

require("core-js/modules/esnext.observable.js");

require("core-js/modules/esnext.promise.all-settled.js");

require("core-js/modules/esnext.promise.any.js");

require("core-js/modules/esnext.promise.try.js");

require("core-js/modules/esnext.reflect.define-metadata.js");

require("core-js/modules/esnext.reflect.delete-metadata.js");

require("core-js/modules/esnext.reflect.get-metadata.js");

require("core-js/modules/esnext.reflect.get-metadata-keys.js");

require("core-js/modules/esnext.reflect.get-own-metadata.js");

require("core-js/modules/esnext.reflect.get-own-metadata-keys.js");

require("core-js/modules/esnext.reflect.has-metadata.js");

require("core-js/modules/esnext.reflect.has-own-metadata.js");

require("core-js/modules/esnext.reflect.metadata.js");

require("core-js/modules/esnext.set.add-all.js");

require("core-js/modules/esnext.set.delete-all.js");

require("core-js/modules/esnext.set.difference.js");

require("core-js/modules/esnext.set.every.js");

require("core-js/modules/esnext.set.filter.js");

require("core-js/modules/esnext.set.find.js");

require("core-js/modules/esnext.set.from.js");

require("core-js/modules/esnext.set.intersection.js");

require("core-js/modules/esnext.set.is-disjoint-from.js");

require("core-js/modules/esnext.set.is-subset-of.js");

require("core-js/modules/esnext.set.is-superset-of.js");

require("core-js/modules/esnext.set.join.js");

require("core-js/modules/esnext.set.map.js");

require("core-js/modules/esnext.set.of.js");

require("core-js/modules/esnext.set.reduce.js");

require("core-js/modules/esnext.set.some.js");

require("core-js/modules/esnext.set.symmetric-difference.js");

require("core-js/modules/esnext.set.union.js");

require("core-js/modules/esnext.string.at.js");

require("core-js/modules/esnext.string.code-points.js");

require("core-js/modules/esnext.string.match-all.js");

require("core-js/modules/esnext.string.replace-all.js");

require("core-js/modules/esnext.symbol.dispose.js");

require("core-js/modules/esnext.symbol.observable.js");

require("core-js/modules/esnext.symbol.pattern-match.js");

require("core-js/modules/esnext.weak-map.delete-all.js");

require("core-js/modules/esnext.weak-map.from.js");

require("core-js/modules/esnext.weak-map.of.js");

require("core-js/modules/esnext.weak-set.add-all.js");

require("core-js/modules/esnext.weak-set.delete-all.js");

require("core-js/modules/esnext.weak-set.from.js");

require("core-js/modules/esnext.weak-set.of.js");

require("core-js/modules/web.dom-collections.for-each.js");

require("core-js/modules/web.dom-collections.iterator.js");

require("core-js/modules/web.immediate.js");

require("core-js/modules/web.queue-microtask.js");

require("core-js/modules/web.url.js");

require("core-js/modules/web.url.to-json.js");

require("core-js/modules/web.url-search-params.js");

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var c = 1;

function test() {
  new Promise();
}

test();

var a = /*#__PURE__*/_createClass(function a() {
  _classCallCheck(this, a);
});
```

配置`@babel/preset-env`预设
配置`useBuiltIns`字段为`entry`
配置`corejs`字段为`3`
不配置`@babel/plugin-transform-runtime`插件。
此时进行语法转化的同时也添加了在`targets`之内的`polyfill`。可是引入了特别多的包，实际使用时不推荐这么配置。

# 配置三
配置：
```json
{
  "presets": [
    [
      "@babel/preset-env",
      {
        "targets": "> 0.25%, not dead",
        "useBuiltIns": "usage",
        "corejs": 3
      }
    ]
  ]
}
```

输出：
```javascript
"use strict";

require("core-js/modules/es.object.define-property.js");

require("core-js/modules/es.object.to-string.js");

require("core-js/modules/es.promise.js");

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var c = 1;

function test() {
  new Promise();
}

test();

var a = /*#__PURE__*/_createClass(function a() {
  _classCallCheck(this, a);
});
```

配置`@babel/preset-env`预设
配置`useBuiltIns`字段为`usage`
不配置`@babel/plugin-transform-runtime`插件。
此时既对语法进行进行了转化(`const`、`class` 关键字等)，而且是按需添加的Polyfill

# 配置一、配置二、配置三总结
 - 配置一：只对语法转换，不添加polyfill
 - 配置二：对语法转换，也添加ployfill，只不过是添加所有的ployfill，这样会导致转换后的代码庞大。
 - 配置三：对语法转换，按需添加ployfill。

正常情况下配置三已经够用了，但是在特殊情况下也会导致新的问题：
 - 添加的ployfill包，污染全局API(在库的开发时容易影响上层用户的代码)
 - 引入的辅助函数在重复生成，例如配置三生成的代码中加入了 `_defineProperties` , `_createClass`, `_classCallCheck` 三个辅助函数，那么生成每个js文件都会有相同的代码，打包后会引起代码大小增加。

为了解决上述两个问题，需要借助`@babel/plugin-transform-runtime`插件。

# 配置四
配置：
```json
{
  "presets": [
    [
      "@babel/preset-env",
      {
        "targets": "> 0.25%, not dead",
        "useBuiltIns": "usage",
        "corejs": 3
      }
    ]
  ],
  "plugins": [
    [
      "@babel/plugin-transform-runtime"
    ]
  ]
}
```

输出：
```javascript
"use strict";

var _interopRequireDefault = require("@babel/runtime/helpers/interopRequireDefault");

var _createClass2 = _interopRequireDefault(require("@babel/runtime/helpers/createClass"));

var _classCallCheck2 = _interopRequireDefault(require("@babel/runtime/helpers/classCallCheck"));

require("core-js/modules/es.object.to-string.js");

require("core-js/modules/es.promise.js");

var c = 1;

function test() {
  new Promise();
}

test();
var a = /*#__PURE__*/(0, _createClass2.default)(function a() {
  (0, _classCallCheck2.default)(this, a);
});
```

配置`@babel/preset-env`预设
配置`useBuiltIns`字段为`usage`
配置`@babel/plugin-transform-runtime`插件。
可以看到之前的`_defineProperties`,`_createClass`,`_classCallCheck`函数已经通过`require`的方式进行导入了，那么在打包工具打包时就不会有重复的代码。
现在已经解决了辅助函数重复的问题。如果需要解决ployfill包影响全局API的问题请看配置五。

# 配置五
配置：
```json
{
  "presets": [
    [
      "@babel/preset-env",
      {
        "targets": "> 0.25%, not dead",
        "useBuiltIns": "usage",
        "corejs": 3
      }
    ]
  ],
  "plugins": [
    [
      "@babel/plugin-transform-runtime",
      {
        "corejs": 3
      }
    ]
  ]
}
```

输出：
```javascript
"use strict";

var _interopRequireDefault = require("@babel/runtime-corejs3/helpers/interopRequireDefault");

var _createClass2 = _interopRequireDefault(require("@babel/runtime-corejs3/helpers/createClass"));

var _classCallCheck2 = _interopRequireDefault(require("@babel/runtime-corejs3/helpers/classCallCheck"));

var _promise = _interopRequireDefault(require("@babel/runtime-corejs3/core-js-stable/promise"));

var c = 1;

function test() {
  new _promise.default();
}

test();
var a = /*#__PURE__*/(0, _createClass2.default)(function a() {
  (0, _classCallCheck2.default)(this, a);
});
```

配置`@babel/preset-env`预设
配置`useBuiltIns`字段为`usage`
配置`@babel/plugin-transform-runtime`插件，添加`corejs`字段配置为`3`

可以看到使用的`Promise`已经不是全局对象，现在变成了使用`@babel/runtime-corejs3`提供的方法。

# 配置六
配置：
```json
{
  "presets": [
    [
      "@babel/preset-env",
      {
        "targets": "> 0.25%, not dead",
        "useBuiltIns": false
      }
    ]
  ],
  "plugins": [
    [
      "@babel/plugin-transform-runtime",
      {
        "corejs": 3
      }
    ]
  ]
}
```

输出：
```javascript
"use strict";

var _interopRequireDefault = require("@babel/runtime-corejs3/helpers/interopRequireDefault");

var _createClass2 = _interopRequireDefault(require("@babel/runtime-corejs3/helpers/createClass"));

var _classCallCheck2 = _interopRequireDefault(require("@babel/runtime-corejs3/helpers/classCallCheck"));

var _promise = _interopRequireDefault(require("@babel/runtime-corejs3/core-js-stable/promise"));

var c = 1;

function test() {
  new _promise.default();
}

test();
var a = /*#__PURE__*/(0, _createClass2.default)(function a() {
  (0, _classCallCheck2.default)(this, a);
});
```

配置`@babel/preset-env`预设
配置`useBuiltIns`字段为`false`,删除`corejs`字段
配置`@babel/plugin-transform-runtime`插件，添加`corejs`字段配置为`3`

当`useBuiltIns`为`false`时可以看到结果和配置五一模一样。
个人猜测，这是因为`plugins`的执行在`presets`之前，先通过`plugins`代码转化，等到`presets`时因为没有使用新的的API(`Promise`已经被转换为`_promise.default`来调用),所以不需要添加polyfill,所以`presets`只进行了语法转换。

# 总结
 - 如果不考虑污染全局API(普通业务代码开发)就使用配置四
 - 否则就使用配置六(配置五效果相同，但是配置容易导致歧义)

上述是作者测试下来的结果，理解得不一定正确，也可能在新babel版本中会改变，如果有疑问可以留言或者提交issue。
