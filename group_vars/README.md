# About group vars

## all.yml

include configuration

* etcd
* docker

## kubernetes.yml

include configuration

* kubernetes version
* addon version
    * coredns
    * canal
    * ...
* kubelet
* kube-proxy

## master.yml

include configuration

* apiServer
* scheduler
* controllerManager