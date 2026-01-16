# 安装

https://github.com/nikkinikki-org/OpenWrt-momo

# 基础模板

```json
{
  "log": {
    "level": "warn",
    "timestamp": true
  },
  "experimental": {
    "clash_api": {
      "external_controller": "0.0.0.0:9090",
      "external_ui": "ui",
      "external_ui_download_url": "https://github.com/Zephyruso/zashboard/releases/latest/download/dist-no-fonts.zip",
      "external_ui_download_detour": "Proxy",
      "default_mode": "Rule"
    }
  },
  "dns": {
    "servers": [
      {
        "type": "https",
        "server": "1.1.1.1",
        "detour": "Proxy",
        "tag": "dns_proxy"
      },
      {
        "type": "https",
        "server": "223.5.5.5",
        "tag": "dns_direct"
      }
    ],
    "rules": [
      {
        "clash_mode": "Proxy",
        "server": "dns_proxy"
      },
      {
        "clash_mode": "Direct",
        "server": "dns_direct"
      },
      {
        "rule_set": "geosite-cn",
        "server": "dns_direct"
      },
      {
        "type": "logical",
        "mode": "and",
        "rules": [
          {
            "rule_set": "geolocation-!cn",
            "invert": true
          },
          {
            "rule_set": "geoip-cn"
          }
        ],
        "server": "dns_proxy",
        "client_subnet": "114.114.114.114/24"
      }
    ],
    "strategy": "ipv4_only"
  },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "listen_port": 7890,
      "tag": "mixed-in",
      "type": "mixed",
      "users": [],
      "sniff": true
    },
    {
      "type": "direct",
      "tag": "dns-in",
      "listen": "0.0.0.0",
      "listen_port": 6450
    },
    {
      "type": "redirect",
      "tag": "redirect-in",
      "listen": "0.0.0.0",
      "listen_port": 6451,
      "sniff": true
    },
    {
      "type": "tproxy",
      "tag": "tproxy-in",
      "listen": "0.0.0.0",
      "listen_port": 6452,
      "sniff": true
    }
  ],
  "outbounds": [
    {
      "type": "selector",
      "tag": "Proxy",
      "outbounds": [
        "自动选择:香港",
        "自动选择",
        "Direct"
      ]
    },
    {
      "type": "selector",
      "tag": "国内流量",
      "outbounds": [
        "Direct",
        "Proxy"
      ]
    },
    {
      "type": "selector",
      "tag": "AI",
      "outbounds": [
        "自动选择:美国"
      ]
    },
    {
      "tag": "自动选择",
      "type": "urltest",
      "outbounds": [],
      "url": "http://www.gstatic.com/generate_204",
      "interval": "10m",
      "tolerance": 50
    },
    {
      "tag": "自动选择:香港",
      "type": "urltest",
      "outbounds": [],
      "url": "http://www.gstatic.com/generate_204",
      "interval": "10m",
      "tolerance": 50
    },
    {
      "tag": "自动选择:美国",
      "type": "urltest",
      "outbounds": [],
      "url": "http://www.gstatic.com/generate_204",
      "interval": "10m",
      "tolerance": 50
    },
    {
      "type": "direct",
      "tag": "Direct"
    }
  ],
  "route": {
    "auto_detect_interface": true,
    "default_domain_resolver": "dns_direct",
    "rules": [
      {
        "action": "sniff"
      },
      {
        "inbound": "dns-in",
        "action": "hijack-dns"
      },
      {
        "protocol": "dns",
        "action": "hijack-dns"
      },
      {
        "clash_mode": "Direct",
        "outbound": "Direct"
      },
      {
        "rule_set": "geosite-private",
        "outbound": "Direct"
      },
      {
        "ip_is_private": true,
        "outbound": "Direct"
      },
      {
        "rule_set": [
          "geosite-cn",
          "geoip-cn"
        ],
        "outbound": "国内流量"
      },
      {
        "rule_set": [
          "OpenAI",
          "Claude",
          "Gemini",
          "Github Copilot"
        ],
        "outbound": "AI"
      },
      {
        "clash_mode": "Proxy",
        "outbound": "Proxy"
      }
    ],
    "rule_set": [
      {
        "tag": "geosite-cn",
        "type": "remote",
        "format": "binary",
        "url": "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/cn.srs",
        "download_detour": "Direct"
      },
      {
        "tag": "geolocation-!cn",
        "type": "remote",
        "format": "binary",
        "url": "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/geolocation-!cn.srs",
        "download_detour": "Direct"
      },
      {
        "tag": "geoip-cn",
        "type": "remote",
        "format": "binary",
        "url": "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geoip/cn.srs",
        "download_detour": "Direct"
      },
      {
        "tag": "geosite-private",
        "type": "remote",
        "format": "binary",
        "url": "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/private.srs",
        "download_detour": "Direct"
      },
      {
        "tag": "OpenAI",
        "type": "remote",
        "format": "binary",
        "url": "https://testingcf.jsdelivr.net/gh/Repcz/tool@X/sing-box/Rules/OpenAI.srs",
        "download_detour": "Direct"
      },
      {
        "tag": "Claude",
        "type": "remote",
        "format": "binary",
        "url": "https://testingcf.jsdelivr.net/gh/Repcz/tool@X/sing-box/Rules/Claude.srs",
        "download_detour": "Direct"
      },
      {
        "tag": "Gemini",
        "type": "remote",
        "format": "binary",
        "url": "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/google-gemini.srs",
        "download_detour": "Direct"
      },
      {
        "tag": "Github Copilot",
        "type": "inline",
        "rules": [
          {
            "domain_suffix": "githubcopilot.com"
          }
        ]
      }
    ]
  }
}
```

# 自用模板(私有)

https://github.com/Curtion/proxy/blob/main/sing-box/json/template.json