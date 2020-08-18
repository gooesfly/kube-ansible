#!/bin/bash
command -v yum &> /dev/null && export PKG=yum
command -v apt &> /dev/null && export PKG=apt
${PKG} update -y
${PKG} install python python-pip sshpass curl rsync -y
pip install --upgrade -i https://mirrors.aliyun.com/pypi/simple/ "ansible==2.9.7"
chmod +x /usr/local/bin/ansible*