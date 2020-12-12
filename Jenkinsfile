pipeline {
    agent any

    parameters {
        choice(name: 'OS', choices: ['CentOS-7.7-16G', 'CentOS-7.8-16G', 'CentOS-8.2-16G', 'Ubuntu-16.04-16G', 'Ubuntu-18.04-16G' ], description: 'OS Template')
    }

    stages {
        stage('checkout') {
            steps {
                git 'https://github.com/buxiaomo/kube-ansible.git'
            }
        }

        stage('create vm') {
            steps {
                dir('test/terraform/vsphere') {
                    sh '/usr/local/bin/terraform init -no-color'
                    withCredentials([string(credentialsId: 'vsphere_server', variable: 'vsphere_server'), string(credentialsId: 'vsphere_user', variable: 'vsphere_user'), string(credentialsId: 'vsphere_password', variable: 'vsphere_password')]) {
                        sh '/usr/local/bin/terraform plan -no-color -var vsphere_server=$vsphere_server -var vsphere_user=$vsphere_user -var vsphere_password=$vsphere_password -var vsphere_virtual_machine_template=${OS}'
                    }
                    withCredentials([string(credentialsId: 'vsphere_server', variable: 'vsphere_server'), string(credentialsId: 'vsphere_user', variable: 'vsphere_user'), string(credentialsId: 'vsphere_password', variable: 'vsphere_password')]) {
                        sh '/usr/local/bin/terraform apply -auto-approve -no-color -var vsphere_server=$vsphere_server -var vsphere_user=$vsphere_user -var vsphere_password=$vsphere_password -var vsphere_virtual_machine_template=${OS}'
                    }
                }
            }
        }

        stage('deploy kubernetes') {
            steps {
                withDockerContainer(args: '-u root', image: 'python:3.8') {
                    sh 'make runtime'
                    sh 'cp ./group_vars/template.yml ./group_vars/all.yml'
                    sh 'sed -i "s/^#.ansible_ssh_pass.*/ansible_ssh_pass: \'root\'/g" ./group_vars/all.yml'
                    sh 'sed -i "s/  # ha:/  ha:/g" ./group_vars/all.yml'
                    sh 'sed -i "s/#   vip: 172.16.16.10/  vip: 172.16.4.10/g" ./group_vars/all.yml'
                    sh 'sed -i "s/#   mask: 16/  mask: 16/g" ./group_vars/all.yml'
                    sh 'sed -i "s/network: flannel/network: canal/g" ./group_vars/all.yml'
                    sh 'cp ./inventory/etcd-on-master.template ./inventory/hosts'
                    sh 'make install DOWNLOAD_WAY=official RUNTIME=docker'
                }
            }
        }
    }
}