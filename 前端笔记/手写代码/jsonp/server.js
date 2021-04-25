const express = require('express')
let app = express()
app.get('/sum', (req, res) => {
  let sum = req.query.a + ' ' + req.query.b
  res.end(req.query.callback + '("' + sum + '")')
})
app.listen(3000, () => {
  console.log('启动本地服务')
})