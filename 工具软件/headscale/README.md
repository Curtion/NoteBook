# OpenWRT
openwrt安装脚本

`https://github.com/CH3NGYZ/tailscale-openwrt`


## 公司路由器

`tailscale up --advertise-routes=192.168.88.0/24,192.168.0.0/24 --login-server=https://hs.3gxk.net --accept-routes --accept-dns=false --reset`

## 家用路由器

`tailscale up --advertise-routes=10.10.10.0/24 --login-server=https://hs.3gxk.net --accept-routes --accept-dns=false --reset`

如果需要重新添加路由,需要先`tailscale down`再`tailscale up`

## 配置防火墙

``` shell
iptables -I FORWARD -i tailscale0 -j ACCEPT
iptables -I FORWARD -o tailscale0 -j ACCEPT
iptables -t nat -I POSTROUTING -o tailscale0 -j MASQUERADE
```

# 服务器

## 开启路由发现

`headscale routes enable -r 1`


