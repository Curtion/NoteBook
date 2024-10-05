# 记录一下OpenCLash设置Clash.Meta内核使用Redir-Host模式的方法

已经实现以下效果

 - [x] DNS无污染
 - [x] DNS无泄露
 - [x] AdGuardHome独立部署完美合作

```yaml
dns:
  enable: true
  ipv6: false
  enhanced-mode: redir-host
  listen: 0.0.0.0:7874
  respect-rules: true
  nameserver:
  - tls://8.8.8.8:853
  - tls://1.1.1.1:853
  proxy-server-nameserver:
  - 114.114.114.114
  - 119.29.29.29
  - 8.8.8.8
  - 1.1.1.1
  nameserver-policy:
    geosite:cn,private:
    - 114.114.114.114
```
上述配置都在`覆写设置->DNS设置`中配置

解析流程参考`https://wiki.metacubex.one/config/dns/diagram/`

从上述流程可以得知`nameserver-policy`规则会在`nameserver/fallback`前面执行.那么分流可以在`nameserver-policy`中进行，而无需等到`fallback`。

DNS解析具体信息参考: `https://s.v2ex.com/t/1015534`中的2楼和6楼

# 和AdGuardHome配合

OpenClash关闭`本地 DNS 劫持`, 然后在`dnsmasq`配置界面设置`DNS转发`为AdGuardHome的地址。

`AdGuardHome`中的上游DNS设置为`OpenClash`的DNS地址。

关闭`AdGuardHome`的`DNS缓存`功能。

**修改`dnsmasq`的配置,禁用缓存, 同时设置`noresolv`为`1`** (非常重要)
