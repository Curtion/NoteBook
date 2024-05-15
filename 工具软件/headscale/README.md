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

## 自定义配置防火墙

``` shell
iptables -I FORWARD -i tailscale0 -j ACCEPT
iptables -I FORWARD -o tailscale0 -j ACCEPT
iptables -t nat -I POSTROUTING -o tailscale0 -j MASQUERADE
```

## GUI配置防火墙

创建一个`tailscale0`接口的防火墙

# 服务器

## 开启路由发现

`headscale routes enable -r 1`


