SHELL := /bin/bash

ANSIBLE_OPT := 
# binary file download way, official、nexus or local
DOWNLOAD_WAY := official

# binary version
KUBE_VERSION := 1.20.0
ETCD_VERSION := 3.4.13
CNI_VERSION := 0.8.5

# container runtime. containerd or docker
RUNTIME := docker
DOCKER_VERSION := 20.10.0

CONTAINERD_VERSION := 1.3.0
CRICTL_VERSION := 1.16.1
RUNC_VERSION := 1.0.0-rc92

# nexus information
NEXUS_DOMAIN_NAME := 
NEXUS_REPOSITORY := kube-ansible
NEXUS_HTTP_USERNAME := 
NEXUS_HTTP_PASSWORD := 

install:
	@echo -e "\033[32mDeploy kubernetes...\033[0m"
	@[ -f group_vars/all.yml ] || ( echo -e "\033[31mPlease Create group vars...\033[0m" && exit 1 )
	@[ -f ./inventory/hosts ] || ( echo -e "\033[31mPlease Create asset information...\033[0m" && exit 1 )
	@ansible-playbook -i ./inventory/hosts install.yml \
		-e DOWNLOAD_WAY=$(DOWNLOAD_WAY) \
		-e RUNTIME=$(RUNTIME) \
		-e KUBE_VERSION=$(KUBE_VERSION) \
		-e ETCD_VERSION=$(ETCD_VERSION) \
		-e CONTAINERD_VERSION=$(CONTAINERD_VERSION) \
		-e RUNC_VERSION=$(RUNC_VERSION) \
		-e CRICTL_VERSION=$(CRICTL_VERSION) \
		-e DOCKER_VERSION=$(DOCKER_VERSION) \
		-e CNI_VERSION=$(CNI_VERSION) \
		-e NEXUS_HTTP_USERNAME=$(NEXUS_HTTP_USERNAME) \
		-e NEXUS_HTTP_PASSWORD=$(NEXUS_HTTP_PASSWORD) \
		-e NEXUS_DOMAIN_NAME=$(NEXUS_DOMAIN_NAME) \
		-e NEXUS_REPOSITORY=$(NEXUS_REPOSITORY) $(ANSIBLE_OPT)
	@@echo -e "\033[32mDeploy kubernetes done, please check the pod status.\033[0m"

scale: 
	@echo -e "\033[32mScale kubernetes node...\033[0m"
	@ansible-playbook -i ./inventory/hosts scale.yml

upgrade: 
	@echo -e "\033[32mUpgrade kubernetes...\033[0m"
	@ansible-playbook -i ./inventory/hosts upgrade.yml

uninstall:
	@echo -e "\033[32mUninstall kubernetes...\033[0m"
	@ansible-playbook -i ./inventory/hosts uninstall.yml

# download:
# 	@echo -e "\033[32mDownload the binaries package to ./scripts/binaries directory...\033[0m"
# 	@export DEBUG=$(DEBUG) \
# 	&& export KUBE_VERSION=$(KUBE_VERSION) \
# 	&& export DOCKER_VERSION=$(DOCKER_VERSION) \
# 	&& export FLANNEL_VERSION=$(FLANNEL_VERSION) \
# 	&& export ETCD_VERSION=$(ETCD_VERSION) \
# 	&& export CNI_VERSION=$(CNI_VERSION) \
# 	&& export NEXUS_HTTP_USERNAME=$(NEXUS_HTTP_USERNAME) \
# 	&& export NEXUS_HTTP_PASSWORD=$(NEXUS_HTTP_PASSWORD) \
# 	&& export NEXUS_DOMAIN_NAME=$(NEXUS_DOMAIN_NAME) \
# 	&& export NEXUS_REPOSITORY=$(NEXUS_REPOSITORY) \
# 	&& bash scripts/$(DOWNLOAD_WAY)-download.sh

runtime:
	@echo -e "\033[32mDeploy ansible...\033[0m"
	@scripts/runtime.sh

# sync:
# 	@echo -e "\033[32mSync binary...\033[0m"
# 	@echo "Sync docker binaries from scripts/binaries"
# 	@rsync -a ./scripts/binaries/docker/$(DOCKER_VERSION)/* ./roles/docker/files/ --delete
# 	@echo "Sync etcd binaries from scripts/binaries"
# 	@rsync -a ./scripts/binaries/etcd/$(ETCD_VERSION)/* ./roles/etcd/files/ --delete
# 	@echo "Sync kubernetes binaries from scripts/binaries"
# 	@rsync -a ./scripts/binaries/kubernetes/$(KUBE_VERSION)/kube-apiserver ./roles/kube-apiserver/files/kube-apiserver --delete	
# 	@rsync -a ./scripts/binaries/kubernetes/$(KUBE_VERSION)/kubectl ./roles/kubectl/files/kubectl --delete
# 	@rsync -a ./scripts/binaries/kubernetes/$(KUBE_VERSION)/kubelet ./roles/kubelet/files/kubelet --delete
# 	@rsync -a ./scripts/binaries/kubernetes/$(KUBE_VERSION)/kube-controller-manager ./roles/kube-controller-manager/files/kube-controller-manager --delete
# 	@rsync -a ./scripts/binaries/kubernetes/$(KUBE_VERSION)/kube-scheduler ./roles/kube-scheduler/files/kube-scheduler --delete
# 	@rsync -a ./scripts/binaries/kubernetes/$(KUBE_VERSION)/kube-proxy ./roles/kube-proxy/files/kube-proxy --delete
# 	@echo "Sync cni-plugins binaries from scripts/binaries"
# 	@rsync -a ./scripts/binaries/cni-plugins/$(CNI_VERSION)/* ./roles/cni-plugins/files/ --delete
# 	@echo -e "\033[32mPlaybook is ready. Enjoy!\033[0m"

.PHONY: test
test:
	@make runtime
	@[ -f ~/.ssh/id_rsa ] || ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
	@sshpass -p root ssh-copy-id -o StrictHostKeyChecking=no root@172.16.4.11
	@sshpass -p root ssh-copy-id -o StrictHostKeyChecking=no root@172.16.4.12
	@sshpass -p root ssh-copy-id -o StrictHostKeyChecking=no root@172.16.4.13
	@sshpass -p root ssh-copy-id -o StrictHostKeyChecking=no root@172.16.4.14
	@sshpass -p root ssh-copy-id -o StrictHostKeyChecking=no root@172.16.4.15
	@sshpass -p root ssh-copy-id -o StrictHostKeyChecking=no root@172.16.4.16
	@cp -f ./group_vars/test.yml ./group_vars/all.yml
	@cp -f ./inventory/test.template ./inventory/hosts
	@make install DOWNLOAD_WAY=official RUNTIME=containerd

version: 
	@command -v jq > /dev/null 2>&1 || ( echo -e "\033[32mPlease install jq\033[0m" &&  exit 1)
	@echo "etcd" > .etcd
	@curl -s `curl -s https://api.github.com/repos/coreos/etcd/releases | jq -r .url` | jq -r '.[].name' | grep -Ev 'rc|beta|alpha' | sed 's/v//g' | head -n 15 | sort -r >> .etcd
	@echo "docker" > .docker
	@curl -s https://api.github.com/repos/docker/docker-ce/releases | jq -r '.[].name' | grep -Ev 'rc|beta|alpha' | sed 's/v//g' | head -n 15 | sort -r >> .docker
	@echo "kubernetes" > .kubernetes
	@curl -s https://api.github.com/repos/kubernetes/kubernetes/releases | jq -r '.[].name' | grep -Ev 'rc|beta|alpha' | sed 's/v//g' | sed 's/Kubernetes //g' | head -n 15 | sort -r >> .kubernetes
	@paste -d '|' .etcd .docker .kubernetes | column -t -s '|'