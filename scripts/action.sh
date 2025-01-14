#!/bin/bash
set -x

function kubernetes() {
  export tag_name=$(curl -s -k -f --connect-timeout 20 --retry 5 --location --insecure https://api.github.com/repos/kubernetes/kubernetes/releases/latest | jq -r .tag_name)
  ls
  pwd
  grep -E "KUBE_VERSION:=${tag_name:1}" ./Makefile
  if [ $? -ne 0 ]; then
    sed -i "8s/KUBE_VERSION.*/KUBE_VERSION:=${tag_name:1}/" ./Makefile
    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"
    git add ./Makefile
    git commit -am "auto update kubernetes version to ${tag_name}"
    git push
  fi
}

$@
