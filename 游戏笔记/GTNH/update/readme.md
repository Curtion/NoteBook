# 更新步骤

该文档仅限于个人使用，请参考使用，不可全部照搬!!!

## 服务端

复制当前`./server/config`和`./server/mods`文件夹到新实例

以下文件夹/文件需要从旧实例到新实例：

 - `visualprospecting`
 - `eula.txt`
 - `World`
 - `config.toml`
 - `aroma_backup_cos-linux-x64`

启动前准备：
 - 修改新实例 `server.properties`
   - `online-mode=false`(设置离线服务器)
   - `white-list=false`(关闭白名单)

## 客户端

复制当前`./client/mods`文件夹到新实例

以下文件夹/文件需要从旧实例到新实例：

  -  `TCNodeTracker` 神秘时代节点
  -  `options.txt`  按键设置等
  -  `journeymap` 旅行地图
  -  `optionsof.txt` Optifine配置
  -  `optionsshaders.txt` 光影配置
  -  `shaderpacks` 光影文件夹
  -  `resourcepacks` 资源文件夹
  -  `config/InGameInfoXML.cfg` 左上角信息样式(可选)
  -  `Waila`显示设置(可选)
     -  `config/Waila.cfg`
     -  `config/WailaHarvestability.cfg`
     -  `wailaplugins.cfg`

# 汉化

`https://github.com/Kiwi233/Translation-of-GTNH`

# 其它：

## 2.1.2.3qf

如果`opencomputers`提示合成表不完整，那么修改`config/opencomputers/gtnh.recipes`,在最后添加:
```
configuratorUpgrade =  true

ritegUpgrade = true

```

原因是GTNH魔改/加入了这俩的配方，但是没有把它的消息加入到合成表中，所以会报错，但是不会影响合成，因为这俩物品合成配方并不由`opencomputers`mod控制。

# Forge迁移Thermos

帮助： https://github.com/GTNewHorizons/GT-New-Horizons-Modpack/issues/6262

 - 添加`AMDIForge`
 - 添加`Gambiarras_BQThermosFix`
 - 下载`https://github.com/CyberdyneCC/Thermos/releases/download/58/Thermos-1.7.10-1614-server.jar`
 - 启动命令中修改为`Thermos`核心