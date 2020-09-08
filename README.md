# kube-ansible

This project will used ansible to deployment kubernetes.

Refer to the `README.md` and `group_vars/template.yml` files for project configuration

## Cloud Support

* [x] Azure
* [x] Aws(Apiserver HA use the CLB)
* [x] GCP(Apiserver HA use the TCP Load balancing)

## OS Support

* [x] CentOS 7.*
* [x] CentOS 8.*
* [x] Ubuntu 16.04.6
* [ ] Ubuntu 18.04.6

## Kubernetes Support

* [x] 1.14.x
* [x] 1.15.x
* [x] 1.16.x
* [x] 1.17.x
* [x] 1.18.x
* [x] 1.19.x

## Size of master and master components

### GCP

* 1-5 nodes: n1-standard-1
* 6-10 nodes: n1-standard-2
* 11-100 nodes: n1-standard-4
* 101-250 nodes: n1-standard-8
* 251-500 nodes: n1-standard-16
* more than 500 nodes: n1-standard-32

### AWS

* 1-5 nodes: m3.medium
* 6-10 nodes: m3.large
* 11-100 nodes: m3.xlarge
* 101-250 nodes: m3.2xlarge
* 251-500 nodes: c4.4xlarge
* more than 500 nodes: c4.8xlarge

## How to use

### Preparation work

#### Clone code

```
# ubuntu
apt install git make -y
# centos
yum install git make -y
git clone https://github.com/buxiaomo/kube-ansible.git /usr/local/src/kube-ansible
cd /usr/local/src/kube-ansible
```

#### Install ansible

```
make runtime
```

#### <span id = "download">Download binaries</span>

if you want to use local package files, reference [here](#local).

if you want to download package from nexus, reference [here](#nexus).

| Parameter  | describe  |  Default | option |
|---|---|---|---|
| DOWNLOAD_WAY | Binary download mode  | official  | official or nexus or qiniu| 
| KUBE_VERSION | Kubernetes binary version  | 1.16.13  | N/A | 
| DOCKER_VERSION | Docker binary version  | 19.03.9  | N/A | 
| ETCD_VERSION | Etcd binary version  | 3.4.5  | N/A | 
| CNI_VERSION | CNI binary version  | 0.8.5  | N/A | 
| NEXUS_HTTP_USERNAME | Nexus username  | N/A  | N/A | 
| NEXUS_HTTP_PASSWORD | Nexus password  | N/A  | N/A | 
| NEXUS_DOMAIN_NAME | Nexus domain name  | nexus.xiaomo.site  | N/A | 
| NEXUS_REPOSITORY | binary repository name, you can use 'upload-nexus.py'  | N/A  | N/A | 

##### official download

```
make download DOWNLOAD_WAY=official
```

##### nexus download

```
make download DOWNLOAD_WAY=nexus \
NEXUS_DOMAIN_NAME=nexus.xiaomo.site \
NEXUS_REPOSITORY=kube-ansible \
NEXUS_HTTP_USERNAME=admin \
NEXUS_HTTP_PASSWORD=admin \
KUBE_VERSION=1.16.8 \
DOCKER_VERSION=19.03.8 \
FLANNEL_VERSION=0.12.0 \
ETCD_VERSION=3.4.5
```

### Kubernetes management

#### Deploy

[![asciicast](https://asciinema.org/a/325326.svg)](https://asciinema.org/a/325326)

```
# default version
make sync
make install

# custom version
make sync KUBE_VERSION=1.14.4
make install KUBE_VERSION=1.14.4 DOCKER_VERSION=19.03.8 FLANNEL_VERSION=0.12.0 ETCD_VERSION=3.4.5
```

#### Scale

add node to `hosts` file.

```
# default version
make scale

# custom version
make scale KUBE_VERSION=1.16.8 DOCKER_VERSION=19.03.8 FLANNEL_VERSION=0.12.0 ETCD_VERSION=3.4.5
```

#### Upgrade

Download new kubernetes binaries, Reference [here](#download).

```
make upgrade KUBE_VERSION=1.18.5
```

### Kubernetes Extended application

This repo only deploy a kubernetes cluster and core application like 'coredns', 'calico', 'canal', 'flannel', not support extended application, like 'jenkins', 'ingress'...

if you want to deploy extended application, please reference [here](https://github.com/buxiaomo/kubernetes-manifests.git).

## <span id = "nexus">about nexus package</span>

create an raw repository, and upload the binaries package.

you can use `scripts/upload-nexus.py` file

component attributes of directory format:

* /linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz
* /coreos/flannel/releases/download/${FLANNEL_VERSION}/flannel-v${FLANNEL_VERSION}-linux-amd64.tar.gz
* /coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz
* /kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-apiserver
* /kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-controller-manager
* /kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-scheduler
* /kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl
* /kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-proxy
* /kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubelet

## <span id = "local">use local package</span>

download package save to `scripts/src` directory.

package name format:

* docker-${DOCKER_VERSION}.tgz
* flannel-v${FLANNEL_VERSION}-linux-amd64.tar.gz
* etcd-v${ETCD_VERSION}-linux-amd64.tar.gz
* kubernetes-client-linux-amd64.v${KUBE_VERSION}.tar.gz
* kubernetes-server-linux-amd64.v${KUBE_VERSION}.tar.gz
* cni-plugins-linux-amd64-v${CNI_VERSION}.tgz

all version please consistent with the makefile or make command

example: 

```
cd scripts/src
KUBE_VERSION=1.14.4
wget https://download.docker.com/linux/static/stable/x86_64/docker-19.03.8.tgz
wget https://github.com/coreos/flannel/releases/download/v0.12.0/flannel-v0.12.0-linux-amd64.tar.gz
wget https://dl.k8s.io/v${KUBE_VERSION}/kubernetes-client-linux-amd64.tar.gz -O kubernetes-client-linux-amd64.v${KUBE_VERSION}.tar.gz
wget https://dl.k8s.io/v${KUBE_VERSION}/kubernetes-server-linux-amd64.tar.gz -O kubernetes-server-linux-amd64.v${KUBE_VERSION}.tar.gz
wget https://github.com/coreos/etcd/releases/download/v3.4.5/etcd-v3.4.5-linux-amd64.tar.gz
wget https://github.com/containernetworking/plugins/releases/download/v0.8.5/cni-plugins-linux-amd64-v0.8.5.tgz
```

# knowledge

* [kubernetes](https://github.com/kubernetes/kubernetes) 
* [kubernetes command line tools reference](https://kubernetes.io/zh/docs/reference/command-line-tools-reference/feature-gates/)
* [calico](https://docs.projectcalico.org/getting-started/kubernetes/quickstart)
* [canal](https://docs.projectcalico.org/getting-started/kubernetes/flannel/flannel) 
* [flannel](https://github.com/coreos/flannel#flannel)
* [cilium](https://docs.cilium.io/en/stable/gettingstarted/#gs-guide)
* [hubble](https://github.com/cilium/hubble)


<!-- 
kubectl config set-cluster kubernetes \
--certificate-authority=/etc/kubernetes/pki/ca.crt \
--embed-certs=false \
--server=https://172.16.18.10:8443 \
--kubeconfig=/etc/kubernetes/tmp.kubeconfig

kubectl config set-credentials admin \
--client-certificate=/etc/kubernetes/pki/admin.crt \
--client-key=/etc/kubernetes/pki/admin.key \
--embed-certs=false \
--kubeconfig=/etc/kubernetes/tmp.kubeconfig

kubectl config set-context default \
--cluster=kubernetes \
--user=admin \
--kubeconfig=/etc/kubernetes/tmp.kubeconfig

kubectl config use-context default --kubeconfig=/etc/kubernetes/tmp.kubeconfig

openssl_certificate                                           Generate and/...
openssl_certificate_info                                      Provide infor...
openssl_csr                                                   Generate Open...
openssl_csr_info                                              Provide infor...
openssl_dhparam                                               Generate Open...
openssl_pkcs12                                                Generate Open...
openssl_privatekey                                            Generate Open...
openssl_privatekey_info                                       Provide infor...
openssl_publickey

NS
env=
name=
project=


ansible-playbook -i inventory/hosts install.yml -t kube-master --start-at-task "Install some applications"
ansible-playbook -i inventory/hosts install.yml --list-tags
ansible-playbook -i inventory/hosts install.yml --list-tasks
ansible-playbook -i inventory/hosts install.yml -e force=$(force)
ansible-playbook -i inventory/hosts install.yml -t common
ansible-playbook -i inventory/hosts install.yml -t ca
ansible-playbook -i inventory/hosts install.yml -t etcd
ansible-playbook -i inventory/hosts install.yml -t kubernetes-init
ansible-playbook -i inventory/hosts install.yml -t kube-master
ansible-playbook -i inventory/hosts install.yml -t kube-worker
ansible-playbook -i inventory/hosts install.yml -t cleanup
ansible-playbook -i inventory/hosts install.yml -t addons
ansible-playbook -i inventory/hosts install.yml -t apps

Master: 
systemctl stop kube-apiserver.service kube-scheduler.service kube-controller-manager.service kube-proxy.service kubelet.service etcd.service
systemctl start kube-apiserver.service kube-scheduler.service kube-controller-manager.service etcd.service kube-proxy.service kubelet.service
systemctl restart kube-apiserver.service kube-scheduler.service kube-controller-manager.service kube-proxy.service kubelet.service

Minion: 
systemctl stop kube-proxy.service kubelet.service 

    {% if groups['master'] | length == 1 and kubernetes.cloud.type == "local" %}
      {% set KUBE_APISERVER_ADDR=ansible_default_ipv4.address %}
      {% set KUBE_APISERVER_PORT=6443 %}
    {% elif groups['master'] | length != 1 and kubernetes.cloud.type == "local" %}
      {% if kubernetes.ha.vip is defined and kubernetes.ha.mask is defined %}
        {% set KUBE_APISERVER_ADDR=kubernetes.ha.vip %}
        {% set KUBE_APISERVER_PORT=8443 %}
      {% else %}
        {% set KUBE_APISERVER_ADDR=ansible_default_ipv4.address %}
        {% set KUBE_APISERVER_PORT=6443 %}
      {% endif %}
    {% elif groups['master'] | length == 1 and kubernetes.cloud.type != "local" %}
      {% if kubernetes.ha.vip is defined and kubernetes.ha.mask is defined %}
        {% set KUBE_APISERVER_ADDR=kubernetes.ha.vip %}
        {% set KUBE_APISERVER_PORT=6443 %}
      {% else %}
        {% set KUBE_APISERVER_ADDR=ansible_default_ipv4.address %}
        {% set KUBE_APISERVER_PORT=6443 %}
      {% endif %}
    {% elif groups['master'] | length == 1 and kubernetes.cloud.type != "local" %}
      {% if kubernetes.ha.vip is defined and kubernetes.ha.mask is defined %}
        {% set KUBE_APISERVER_ADDR=kubernetes.ha.vip %}
        {% set KUBE_APISERVER_PORT=6443 %}
      {% else %}
        {% set KUBE_APISERVER_ADDR=ansible_default_ipv4.address %}
        {% set KUBE_APISERVER_PORT=6443 %}
      {% endif %}
    {% endif %}
    
    {% if groups['master'] | length == 1 kubernetes.cloud.type == "local" %}
    {% set KUBE_APISERVER_ADDR= %}
    {% set KUBE_APISERVER_PORT=6443 %}
    {% elif groups['master'] | length != 1 kubernetes.cloud.type == "local" and kubernetes.ha is defined %}
    {% set KUBE_APISERVER_ADDR= %}
    {% set KUBE_APISERVER_PORT=6443 %}
    {% else %}
    {% set KUBE_APISERVER_ADDR=ansible_default_ipv4.address %}
    {% set KUBE_APISERVER_PORT=6443 %}

      --server=https://{% if groups['master'] | length !=1 %}{{ kubernetes.ha.vip }}:{% if kubernetes.cloud.type != "local" %}6443{% else %}8443{% endif %}{% else %}{{  }}:{% if kubernetes.cloud.type != "local" %}6443{% else %}8443{% endif %}{% endif %} \


openssl genrsa -out kubelet.key 2048
openssl req -new -key kubelet.key -subj "/CN=system:node:vm018011/O=system:nodes" -out kubelet.csr
openssl x509 -req -in kubelet.csr -CA ca.crt -CAkey ca.key -CAcreateserial -extensions v3_req_client -extfile openssl.cnf -out kubelet.crt -days 3652

kubectl config set-cluster kubernetes \
--certificate-authority=/etc/kubernetes/pki/ca.crt \
--embed-certs=true \
--server=https://172.16.18.10:8443 \
--kubeconfig=/etc/kubernetes/kubelet.kubeconfig

kubectl config set-credentials system:node:vm018011 \
--client-certificate=/etc/kubernetes/pki/kubelet.crt \
--client-key=/etc/kubernetes/pki/kubelet.key \
--embed-certs=true \
--kubeconfig=/etc/kubernetes/kubelet.kubeconfig

kubectl config set-context default \
--cluster=kubernetes \
--user=system:node:vm018011 \
--kubeconfig=/etc/kubernetes/kubelet.kubeconfig

kubectl config use-context default --kubeconfig=/etc/kubernetes/kubelet.kubeconfig


/usr/local/bin/kubelet \
--kubeconfig=/etc/kubernetes/kubelet.kubeconfig \
--config=/etc/kubernetes/kubelet-conf.yml \
--pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.2 \
--image-pull-progress-deadline=2m \
--network-plugin=cni \
--cni-conf-dir=/etc/cni/net.d \
--cni-bin-dir=/opt/cni/bin \
--cert-dir=/etc/kubernetes/pki \
--register-node=true \
--feature-gates=RotateKubeletServerCertificate=true \
--tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256 \
--alsologtostderr=true \
--logtostderr=false \
--log-dir=/var/log/kubernetes/kubelet \
--v=2
-->

<!-- RUNNING HANDLER -->

<!-- 
cat <<EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:kube-apiserver-to-kubelet
rules:
  - apiGroups:
      - ""
    resources:
      - nodes/proxy
      - nodes/stats
      - nodes/log
      - nodes/spec
      - nodes/metrics
    verbs:
      - "*"
EOF

cat <<EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: system:kube-apiserver
  namespace: ""
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:kube-apiserver-to-kubelet
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: kubernetes
EOF


cat <<EOF | sudo tee kubelet-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/var/lib/kubernetes/ca.pem"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  - "10.32.0.10"
podCIDR: "${POD_CIDR}"
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
tlsCertFile: "/var/lib/kubelet/${HOSTNAME}.pem"
tlsPrivateKeyFile: "/var/lib/kubelet/${HOSTNAME}-key.pem"
EOF

cat <<EOF | sudo tee /etc/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=containerd.service
Requires=containerd.service

[Service]
ExecStart=/usr/local/bin/kubelet \
  --config=/var/lib/kubelet/kubelet-config.yaml \
  --image-pull-progress-deadline=2m \
  --kubeconfig=/var/lib/kubelet/kubeconfig \
  --network-plugin=cni \
  --register-node=true \
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF -->