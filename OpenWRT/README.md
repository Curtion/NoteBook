# immortalwrt

使用`immortalwrt`版本OpenWRT

仓库: `https://github.com/immortalwrt/immortalwrt`

下载: `https://firmware-selector.immortalwrt.org/`

# 安装 argon GUI主题

`https://github.com/jerrykuku/luci-theme-argon/blob/master/README_ZH.md#%E5%9C%A8%E5%AE%98%E6%96%B9%E5%92%8C-immortalwrt-%E4%B8%8A%E5%AE%89%E8%A3%85`

 - `luci-theme-argon`是主题本体，只安装就可使用
 - `luci-app-argon-config` 是argon的配置插件, 安装后可在`系统`->`Argon Config`中配置主题样式

# 安装OpenClash

`https://github.com/vernesong/OpenClash`

设置教程 `https://github.com/Aethersailor/Custom_OpenClash_Rules/wiki/OpenClash-%E8%AE%BE%E7%BD%AE%E6%95%99%E7%A8%8B`

# 安装singbox

`https://github.com/vernesong/OpenClash`

# GL-INET安装singbox

由于GL-INET的OpenWRT版本过旧, 使用的是firewall3, 无法直接安装ipk格式的singbox。

1. 下载`https://github.com/SagerNet/sing-box/releases` 选择`openwrt_aarch64_cortex-a53.ipk`版本
2. `tar -xzf sing-box_xxxx_aarch64_cortex-a53.ipk` 解压ipk(直接安装会报firewall4错误)
3. `tar -xzf data.tar.gz -C /` 解压覆盖
4. 修改 `/etc/sing-box/config.json` 配置文件
5. 修改 `/etc/init.d/sing-box` 配置, 新增下面行

>>>
```diff
#!/bin/sh /etc/rc.common

USE_PROCD=1
START=99
PROG="/usr/bin/sing-box"
+TPROXY_SCRIPT="/etc/sing-box/tproxy.sh"

start_service() {
  config_load "sing-box"

  local enabled config_file working_directory
  local log_stderr
  config_get_bool enabled "main" "enabled" "0"
  [ "$enabled" -eq "1" ] || return 0

  config_get config_file "main" "conffile" "/etc/sing-box/config.json"
  config_get working_directory "main" "workdir" "/usr/share/sing-box"
  config_get_bool log_stderr "main" "log_stderr" "1"

  procd_open_instance
  procd_set_param command "$PROG" run -c "$config_file" -D "$working_directory"
  procd_set_param file "$config_file"
  procd_set_param stderr "$log_stderr"
  procd_set_param limits core="unlimited"
  procd_set_param limits nofile="1000000 1000000"
  procd_set_param respawn
  procd_close_instance

+  if [ -f "$TPROXY_SCRIPT" ]; then
+    /bin/sh "$TPROXY_SCRIPT" start
+  fi
}

+stop_service() {
+  if [ -f "$TPROXY_SCRIPT" ]; then
+    /bin/sh "$TPROXY_SCRIPT" stop
+  fi
+}

+reload_service() {
+  stop_service
+  start_service
+}

service_triggers() {
  procd_add_reload_trigger "sing-box"
}
```
6. 新增 `/etc/sing-box/tproxy.sh` 该脚本TCP和UDP都采用`TPROXY`方式

>>>
```shell
#!/bin/sh
TPROXY_PORT=6452

do_stop() {
    echo "Cleaning up TProxy rules..."
    iptables -t mangle -D PREROUTING -j SING_BOX 2>/dev/null
    iptables -t mangle -F SING_BOX 2>/dev/null
    iptables -t mangle -X SING_BOX 2>/dev/null
    ip rule del fwmark 1 table 100 2>/dev/null
    ip route del local 0.0.0.0/0 dev lo table 100 2>/dev/null
}

do_start() {
    do_stop # 先清理旧规则
    echo "Applying TProxy rules..."

    # 创建新规则
    iptables -t mangle -N SING_BOX
    iptables -t mangle -A SING_BOX -d 0.0.0.0/8 -j RETURN
    iptables -t mangle -A SING_BOX -d 127.0.0.0/8 -j RETURN
    iptables -t mangle -A SING_BOX -d 10.0.0.0/8 -j RETURN
    iptables -t mangle -A SING_BOX -d 100.64.0.0/10 -j RETURN
    iptables -t mangle -A SING_BOX -d 172.16.0.0/12 -j RETURN
    iptables -t mangle -A SING_BOX -d 192.168.0.0/16 -j RETURN
    iptables -t mangle -A SING_BOX -d 224.0.0.0/4 -j RETURN
    iptables -t mangle -A SING_BOX -d 255.255.255.255/32 -j RETURN

    # 核心转发
    iptables -t mangle -A SING_BOX -p tcp -j TPROXY --on-port $TPROXY_PORT --tproxy-mark 1
    iptables -t mangle -A SING_BOX -p udp -j TPROXY --on-port $TPROXY_PORT --tproxy-mark 1
    iptables -t mangle -A PREROUTING -j SING_BOX

    # 路由配置
    ip rule add fwmark 1 table 100
    ip route add local 0.0.0.0/0 dev lo table 100
    echo "TProxy rules applied successfully."
}

case "$1" in
    stop)
        do_stop
        ;;
    start|*)
        do_start
        ;;
esac
```

7. 启动服务
`/etc/init.d/sing-box enable`

`/etc/init.d/sing-box start`

# 安装tailscale

[tailscale](../工具软件/headscale/README.md)

# 安装mwan3

用于双wan口故障转移

`opkg install luci-app-mwan3 luci-i18n-mwan3-zh-cn`

mwan3默认支持iptables, 但是不支持nftables, 需要安装`opkg install iptables-nft ip6tables-nft`兼容

## 问题

自动检测会经常失效, 设置ping baidu.com和jd.com都会有失败的情况, 不知原因,已卸载. 后续如果ikuai的ipv6中继支持


# IPV6中继自定义DNS

`/etc/config/dhcp`在`lan`中新增一行 `list dns ''`, 填写`''`会设置为路由器的地址为DNS

查看[原理](https://forum.openwrt.org/t/rewriting-dns-in-relay-mode-in-odhcpd/120574)