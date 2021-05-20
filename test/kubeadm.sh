# kubeadm
apt-get update -y && apt-get install -y apt-transport-https gnupg
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
tee /etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt-get update
apt-get install kubelet-1.19.7 kubeadm-1.19.7 kubectl-1.19.7 -y


cat > /etc/modules-load.d/kubernetes.conf << EOF
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_sh
nf_conntrack_ipv4
EOF

cat > /etc/sysctl.d/100-kubernetes.conf << EOF
fs.file-max=52706963
fs.inotify.max_user_watches=89100
fs.may_detach_mounts=1
fs.nr_open=52706963
kernel.pid_max=65535
net.bridge.bridge-nf-call-arptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.bridge.bridge-nf-call-iptables=1
net.core.netdev_max_backlog=10000
net.ipv4.conf.all.arp_announce=2
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.arp_announce=2
net.ipv4.conf.default.rp_filter=0
net.ipv4.conf.lo.arp_announce=2
net.ipv4.ip_forward=1
net.ipv4.neigh.default.gc_stale_time=120
net.ipv4.tcp_keepalive_intvl=30
net.ipv4.tcp_keepalive_probes=10
net.ipv4.tcp_keepalive_time=600
net.ipv4.tcp_max_syn_backlog=1024
net.ipv4.tcp_max_tw_buckets=5000
net.ipv4.tcp_synack_retries=2
net.ipv4.tcp_syncookies=1
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1
net.netfilter.nf_conntrack_max=10485760
net.netfilter.nf_conntrack_tcp_timeout_close_wait=3600
net.netfilter.nf_conntrack_tcp_timeout_established=300
vm.overcommit_memory=1
vm.panic_on_oom=0
vm.swappiness=0
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF

# docker
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
cat > /etc/docker/daemon.json << EOF
{
    "debug": false,
    "default-ulimits": {
        "nofile": {
            "Hard": 655360,
            "Name": "nofile",
            "Soft": 655360
        }
    },
    "exec-opts": [
        "native.cgroupdriver=systemd"
    ],
    "experimental": false,
    "icc": false,
    "insecure-registries": [
        "dockerhub.qingcloud.com"
    ],
    "live-restore": true,
    "log-driver": "json-file",
    "log-opts": {
        "max-file": "5",
        "max-size": "100m"
    },
    "max-concurrent-downloads": 20,
    "max-concurrent-uploads": 10,
    "registry-mirrors": [
        "https://i3jtbyvy.mirror.aliyuncs.com"
    ],
    "storage-driver": "overlay2",
    "storage-opts": [
        "overlay2.override_kernel_check=true"
    ],
    "userland-proxy": false
}
EOF

systemctl stop ufw
systemctl disable ufw
systemctl enable kubelet
systemctl start kubelet
swapoff -a
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo "source <(kubeadm completion bash)" >> ~/.bashrc
kubeadm --config kubeadm.yaml config images pull
kubeadm init --config /etc/kubeadm.yml --upload-certs

# add nodes
kubeadm token create --print-join-command --config kubeadm.yaml --skip-token-print

# get hash
kubeadm init phase upload-certs --upload-certs --config kubeadm.yaml


# update
kubeadm upgrade apply --config kubeadm.yaml --ignore-preflight-errors all --force --v=5