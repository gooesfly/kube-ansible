#!/bin/bash
command -v yum &> /dev/null && export PKG=yum
command -v apt &> /dev/null && export PKG=apt
case ${PKG} in
    'yum')
        yum install -y epel-release
        yum install python2 python2-pip sshpass curl rsync -y
        ;;
    'apt')
        apt-get update
        apt-get install python2 python2-pip sshpass curl rsync -y
        ;;
    '*')
        echo "unknow OS version."
        exit 1
        ;;
esac
pip install --upgrade -i https://mirrors.aliyun.com/pypi/simple/ "ansible==2.9.6"