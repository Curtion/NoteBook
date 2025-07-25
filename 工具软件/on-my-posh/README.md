# 安装

https://ohmyposh.dev/docs/installation/windows

# Tabby环境变量问题

`Tabby`的环境变量需要重启电脑才会生效, 但是`Windows Terminal`却不需要。

因此可以使用以下脚本解决:

1. `code $profile`
2. 在打开的文件中添加以下内容:

```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

# 配置主题

`oh-my-posh.exe init pwsh --config 'D:\OneDrive\同步\onmyposh\omp.json' | Invoke-Expression`