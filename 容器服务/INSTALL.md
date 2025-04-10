# 说明

在2024年6月左右docker被墙,因此记录国内服务器安装docker的方法。

# Debian 12

## 离线安装

下载`tgz`压缩包: https://download.docker.com/linux/static/stable/x86_64/

 - `sudo -v`
 - `tar -xvf docker-27.1.2.tgz`
 - `cp docker/* /usr/bin`
 - `rm -rf docker docker-27.1.2.tgz`
 - `vim /etc/systemd/system/docker.service`

```bash
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/dockerd
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
```

 - `systemctl daemon-reload`
 - `systemctl enable docker`
 - `systemctl start docker`

### 安装docker-compose

 - 下载二进制文件: https://github.com/docker/compose/releases
 - 重命名为`docker-compose`
 - `chmod +x docker-compose`
 - `mv docker-compose $HOME/.docker/cli-plugins`

后续可以使用`docker compose`命令。

## 使用国内源安装

 - `sudo -v`
 - `curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg`
 - `echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null`
 - `apt-get update`
 - `apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`


## 官方源安装

原文：https://docs.docker.com/engine/install/debian/

 - `sudo -v`
 - `apt-get install ca-certificates curl`
 - `install -m 0755 -d /etc/apt/keyrings`
 - `curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc`
 - `chmod a+r /etc/apt/keyrings/docker.asc`
 - `echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null`
 - `apt-get update`
 - `apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`

