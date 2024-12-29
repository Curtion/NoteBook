# Volta

`Volta`在`package.json`中的`devDependencies`含有指定的包管理器(例如: `pnpm`)时, 会出现错误: `Volta error: Could not locate executable pnpm in your project`

原因: [#1293](https://github.com/volta-cli/volta/issues/1293)

# fnm

在使用Windows的`sudo pnpm dev`时会报错: `'node' is not recognized as an internal or external command, operable program or batch file.`

Issues: [#1343](https://github.com/Schniz/fnm/issues/1343)

使用`sudo -E`传递环境变量解决

在VSCode中使用`simple-git-hooks`+`lint-staged`时, 会出现`fnm: command not found`错误, 本质原因还是环境变量的问题


# vfox