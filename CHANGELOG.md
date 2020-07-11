## v1.0.1

- makefile增加version参数方便获取相关组件版本
- etcd增加auto-compaction-retention参数, 反之大规模集群下有可能出现的bug
- 修复下载脚本中kube检查可执行失败导致重复下载
- 删除addon插件中所有删除step
- 核心组件增加判断逻辑, 防止再次部署时重启核心组件
- master组件增加证书过期检查, 仅在过期前30天才会更新

## v1.0.0

- fix flannel network deployment not successful
- Multi-cluster support
- fix kubernetes version check error
- fix some time apiserver setting error