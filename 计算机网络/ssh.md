# 远程转发(通过远程服务器访问本地计算机)

`ssh -R remote-port:target-host:target-port -N remotehost`

其中 `remote-port`是远程服务器端口, `target-host`是本地主机(可以是localhost,也可以是任何局域网主机), `target-port`是本地端口.

`remotehost`是服务器

## 实例

`ssh -R 80:localhost:8080 -N root@3gxk.net`

把远程服务器的80端口转发到本地主机的8080端口


# 本地转发(本地通过远程服务器访问远程计算机)

`ssh -L local-port:target-host:target-port -N tunnel-host`

其中`local-port`是本地端口, `target-host`是目标主机, `target-port`是目标端口.

作用：访问本地`local-port`端口等同于访问`target-host`:`target-port`主机，通过`tunnel-host`中介访问。

## 实例

`ssh -L 8080:www.baidu.com:80 -N root@3gxk.net`

访问`localhost:8080`等同于通过`root@3gxk.net`访问`www.baidu.com:80`


# 动态转发

`ssh -D local-port -N tunnel-host`

通过`local-port`端口通信信息都使用`tunnel-host`中介访问.

## 实例

`ssh -D 8080 -N root@3gxk.net`

这会在`localhost:8080`上开启一个socks5服务器，此服务器会通过`root@3gxk.net`中转.

# 参数

`-N`表示不执行shell命令