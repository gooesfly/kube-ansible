# About group vars

## all.template

include configuration

* modprobe
* ipvs
* sysctl


## kubernetes.template

include configuration

* docker
* etcd
* ha
* cloudProvider
* apiServer
* controllerManager
* scheduler
* kubelet
* proxy
* addon
* apps
