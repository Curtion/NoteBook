# OpenWRT

`https://openwrt.org/docs/guide-user/services/vpn/tailscale/start`

`opkg update`
`opkg install tailscale`

编辑`/etc/init.d/tailscale`

在最后一个`procd_append_param`下面添加

``` shell
procd_append_param command --tun tailscale0
```

## 公司路由器

`tailscale up --advertise-routes=192.168.88.0/24,192.168.0.0/24,192.168.8.0/24 --login-server=https://hs.3gxk.net --netfilter-mode=off --accept-routes --accept-dns=false --reset`

## 家用路由器

`tailscale up --advertise-routes=10.10.10.0/24 --login-server=https://hs.3gxk.net --netfilter-mode=off --accept-routes --accept-dns=false --reset`


# 防火墙


创建一个`tailscale0`接口的防火墙, 开启`IP动态伪装`和`MSS钳制`

# 服务器

## 创建用户

`headscale users create curtion`

## 注册节点

`headscale nodes register --user curtion --key xxxxxxxxxxxxxxx`

## 开启路由发现

获取ID: `headscale nodes list`
查询路由: `headscale nodes routes`
开启路由发现: `headscale nodes approve-routes -i 1 -r "10.10.10.0/24"`
