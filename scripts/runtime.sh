#!/bin/bash
command -v yum &>/dev/null && export PKG=yum
command -v apt &>/dev/null && export PKG=apt
case ${PKG} in
'yum')
    yum install -y epel-release
    yum install python3 python3-pip sshpass curl rsync -y
    ;;
'apt')
    apt-get update
    apt-get install python3 python3-pip sshpass curl rsync -y
    ;;
'*')
    echo "unknow OS version."
    exit 1
    ;;
esac
pip3 install --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple pip
pip3 install --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple "ansible==4.3.0"