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

# 安装tailscale

[tailscale](../工具软件/headscale/README.md)


# 安装mwan3

用于双wan口故障转移

`opkg install luci-app-mwan3 luci-i18n-mwan3-zh-cn`

mwan3默认支持iptables, 但是不支持nftables, 需要安装`opkg install iptables-nft ip6tables-nft`兼容

## 问题

自动检测会经常失效, 设置ping baidu.com和jd.com都会有失败的情况, 不知原因,已卸载. 后续如果ikuai的ipv6中继支持