# Volta

`Volta`在`package.json`中的`devDependencies`含有指定的包管理器(例如: `pnpm`)时, 会出现错误: `Volta error: Could not locate executable pnpm in your project`

原因: [#1293](https://github.com/volta-cli/volta/issues/1293)

# fnm

在使用Windows的`sudo pnpm dev`时会报错: `'node' is not recognized as an internal or external command, operable program or batch file.`

Issues: [#1343](https://github.com/Schniz/fnm/issues/1343)

使用`sudo -E`传递环境变量解决

在VSCode中使用`simple-git-hooks`+`lint-staged`时, 会出现`fnm: command not found`错误, 本质原因还是环境变量的问题

解决方案: 使用命令行`code`打开VSCode, 这样VSCode会继承当前的环境变量

## 解决方案二

一些第三方软件(例如chatwise)会在系统环境变量中的node/npx等命令, 如果都使用powershell来启动软件会非常的繁琐，此时可以添加以下路径到`PATH`中:

`%USERPROFILE%\AppData\Roaming\fnm\aliases\default`

# vfox