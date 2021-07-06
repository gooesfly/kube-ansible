SHELL := /bin/bash

ANSIBLE_OPT:=
# binary file download way, official nexus qiniu
DOWNLOAD_WAY:=official

# binary version
KUBE_VERSION:=1.21.2
ETCD_VERSION:=3.4.5
CNI_VERSION:=0.9.1

# container runtime. containerd or docker
RUNTIME:=docker
DOCKER_VERSION:=20.10.7

CONTAINERD_VERSION:=1.5.2
CRICTL_VERSION:=1.21.0
RUNC_VERSION:=1.0.0

# nexus information
NEXUS_DOMAIN_NAME:=
NEXUS_REPOSITORY:=kube-ansible
NEXUS_HTTP_USERNAME:=
NEXUS_HTTP_PASSWORD:=

runtime:
	@echo -e "\033[32mDeploy ansible...\033[0m"
	@scripts/runtime.sh

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
	@ansible-playbook -i ./inventory/hosts scale.yml \
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

upgrade: 
	@echo -e "\033[32mUpgrade kubernetes...\033[0m"
	@ansible-playbook -i ./inventory/hosts upgrade.yml \
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

uninstall:
	@echo -e "\033[32mUninstall kubernetes...\033[0m"
	@ansible-playbook -i ./inventory/hosts uninstall.yml

fix:
	@ansible-playbook -i ./inventory/hosts fix-python3.yml

version: 
	@command -v jq > /dev/null 2>&1 || ( echo -e "\033[32mPlease install jq\033[0m" &&  exit 1)
	@echo "etcd" > .etcd
	@curl -s `curl -s https://api.github.com/repos/coreos/etcd/releases | jq -r .url` | jq -r '.[].tag_name' | grep -Ev 'rc|beta|alpha' | sed 's/v//g' | head -n 15 | sort -r -V >> .etcd
	@echo "docker" > .docker
	@curl -s https://api.github.com/repos/moby/moby/releases | jq -r '.[].tag_name' | grep -Ev 'rc|beta|alpha|-ce' | sed 's/v//g' | head -n 15 | sort -r -V >> .docker
	@echo "kubernetes" > .kubernetes
	@curl -s https://api.github.com/repos/kubernetes/kubernetes/releases | jq -r '.[].tag_name' | grep -Ev 'rc|beta|alpha' | sed 's/v//g' | head -n 15 | sort -r -V >> .kubernetes
	@echo "containerd" > .containerd
	@curl -s https://api.github.com/repos/containerd/containerd/releases | jq -r '.[].tag_name' | grep -Ev 'rc|beta|alpha' | sed 's/v//g' | head -n 15 | sort -r -V >> .containerd
	@echo "crictl" > .crictl
	@curl -s https://api.github.com/repos/kubernetes-sigs/cri-tools/releases | jq -r '.[].tag_name' | grep -Ev 'rc|beta|alpha' | sed 's/v//g'| head -n 15 | sort -r -V >> .crictl
	@echo "runc" > .runc
	@curl -s https://api.github.com/repos/opencontainers/runc/releases | jq -r '.[].tag_name' | grep -Ev 'rc|beta|alpha' | sed 's/v//g'| head -n 15 | sort -r -V >> .runc
	@paste -d '|' .etcd .docker .kubernetes .containerd .crictl .runc | column -t -s '|'
	@rm -rf .etcd .docker .kubernetes .containerd .crictl .runc