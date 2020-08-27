## v1.0.2

- 增加七牛OSS下载方式
- 增加k8s各组件日志配置
- 增加Etcd定时备份、用户以及目录和文件权限
- kubelet取消bootstrap token认证改为证书
- 统一配置文件名称格式(配置文件为*.yaml, *.kubeconfig)
- 优化etcd大规模数据量下可能出现的异常问题
- 增加apps role
- 调整目录结构, 修改证书过期验证方式

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