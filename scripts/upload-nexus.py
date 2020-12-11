#!/usr/bin/env python
import os
import json
import requests
import argparse


def Download(url, filename):
    r = requests.get(url)
    with open("./tmp/%s" % filename, "wb") as code:
        code.write(r.content)

class Nexus:
    def __init__(self, protocol, host, repository, username, password):
        self.protocol = protocol
        self.host = host
        self.repository = repository
        self.username = username
        self.password = password

    def Upload(self, src, directory):
        url = '%s://%s/repository/%s' % (self.protocol, self.host, self.repository)
        content = open(src, 'rb').read()
        if self.username != None and self.password != None:
            auth = (self.username, self.password)
            resp = requests.put("%s/%s/%s" % (url, directory, src.replace("./tmp/", "")), data=content, auth=auth)
        else:
            resp = requests.put("%s/%s/%s" % (url, directory, src.replace("./tmp/", "")), data=content)

    # def ListComponents(self):
    #     url = "%s://%s/service/rest/v1/components?repository=%s" % (self.protocol, self.host, self.repository)
    #     if self.username != None and self.password != None:
    #         auth = (self.username, self.password)
    #         resp = requests.get(url, auth=auth)
    #     else:
    #         resp = requests.get(url)
    #     text = json.loads(resp.text)
    #     print(text.get('items'))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Download package and upload to nexus.')
    parser.add_argument('--protocol', default="http", metavar='protocol', help='nexus protocol')
    parser.add_argument('--host', metavar='host', help='nexus host', required=True)
    parser.add_argument('--repository', metavar='repository', help='nexus repository name', required=True)
    parser.add_argument('--username', default=None, metavar='username', help='nexus username')
    parser.add_argument('--password', default=None, metavar='password', help='nexus password')
    parser.add_argument('--docker', default="19.03.9", metavar='docker', help='docker version, default: 19.03.9')
    parser.add_argument('--flannel', default="0.12.0", metavar='flannel', help='flannel version, default: 0.12.0')
    parser.add_argument('--etcd', default="3.4.13", metavar='etcd', help='etcd version, default: 3.4.13')
    parser.add_argument('--kubernetes', default="1.20.0", metavar='kubernetes', help='kubernetes version, default: 1.20.0')
    parser.add_argument('--cni', default="0.8.5", metavar='cni', help='cni plugin version, default: 0.8.5')
    parser.add_argument('--containerd', default="1.3.0", metavar='containerd', help='containerd version, default: 1.3.0')
    parser.add_argument('--runc', default="1.0.0-rc8", metavar='runc', help='runc version, default: 1.0.0-rc8')
    parser.add_argument('--crictl', default="1.16.1", metavar='crictl', help='crictl version, default: 1.16.1')
    options = parser.parse_args()

    if not os.path.exists("tmp"):
        os.makedirs("tmp")

    nexus = Nexus(options.protocol, options.host, options.repository, options.username, options.password)
    # nexus.ListComponents()
    
    print("Download and Upload docker package...")
    Download("https://download.docker.com/linux/static/stable/x86_64/docker-%s.tgz" % options.docker, "docker-%s.tgz" % options.docker)
    nexus.Upload(src="./tmp/docker-%s.tgz" % options.docker, directory="/linux/static/stable/x86_64")

    print("Download and Upload flannel package...")
    Download("https://github.com/coreos/flannel/releases/download/v%s/flannel-v%s-linux-amd64.tar.gz" %(options.flannel, options.flannel), "flannel-v%s-linux-amd64.tar.gz" % options.flannel)
    nexus.Upload(src="./tmp/flannel-v%s-linux-amd64.tar.gz" % options.flannel, directory="/coreos/flannel/releases/download/v%s" % options.flannel)

    print("Download and Upload etcd package...")
    Download("https://github.com/coreos/etcd/releases/download/v%s/etcd-v%s-linux-amd64.tar.gz" % (options.etcd, options.etcd), "etcd-v%s-linux-amd64.tar.gz" % options.etcd)
    nexus.Upload(src="./tmp/etcd-v%s-linux-amd64.tar.gz" % options.etcd, directory="/coreos/etcd/releases/download/v%s" % options.etcd)

    print("Download and Upload kubernetes package...")
    file_list = [
        "kube-apiserver",
        "kube-controller-manager",
        "kube-scheduler",
        "kubectl",
        "kube-proxy",
        "kubelet"
    ]
    for f in file_list:
        print("Download and Upload kubernetes package(%s)..." % f)
        Download("https://storage.googleapis.com/kubernetes-release/release/v%s/bin/linux/amd64/%s" % (options.kubernetes, f), f)
        nexus.Upload(src="./tmp/%s" % f, directory="/kubernetes-release/release/v%s/bin/linux/amd64" % options.kubernetes)

    print("Download and Upload cni-plugins package...")
    Download("https://github.com/containernetworking/plugins/releases/download/v%s/cni-plugins-linux-amd64-v%s.tgz" % (options.cni, options.cni), "cni-plugins-linux-amd64-v%s.tgz" % options.cni)
    nexus.Upload(src="./tmp/cni-plugins-linux-amd64-v%s.tgz" % options.cni, directory="/containernetworking/plugins/releases/download/v%s" % options.cni)

    print("Download and Upload containerd package...")    
    Download("https://github.com/containerd/containerd/releases/download/v%s/containerd-%s.linux-amd64.tar.gz" % (options.containerd, options.containerd), "containerd-%s.linux-amd64.tar.gz" % options.containerd)
    nexus.Upload(src="./tmp/containerd-%s.linux-amd64.tar.gz" % options.containerd, directory="/containerd/containerd/releases/download/v%s" % options.containerd)

    print("Download and Upload runc package...")
    Download("https://github.com/opencontainers/runc/releases/download/v%s/runc.amd64" % (options.runc), "runc.amd64")
    nexus.Upload(src="./tmp/runc.amd64", directory="/opencontainers/runc/releases/download/v%s" % options.runc)

    print("Download and Upload crictl package...")    
    Download("https://github.com/kubernetes-sigs/cri-tools/releases/download/v%s/crictl-v%s-linux-amd64.tar.gz" % (options.crictl, options.crictl), "crictl-v%s-linux-amd64.tar.gz" % options.crictl)
    nexus.Upload(src="./tmp/crictl-v%s-linux-amd64.tar.gz" % options.crictl, directory="/kubernetes-sigs/cri-tools/releases/download/v%s" % options.crictl)