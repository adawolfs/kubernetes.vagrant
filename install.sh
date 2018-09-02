#!/bin/bash

set -x

swapoff -a 
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

yum upgrade -y
yum install -y docker
systemctl enable docker
systemctl start docker

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/sysconfig/selinux
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet
systemctl start kubelet

kubeadm init --apiserver-advertise-address=0.0.0.0 --pod-network-cidr=10.244.0.0/16

kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml

kubectl --kubeconfig=/etc/kubernetes/admin.conf taint nodes --all node-role.kubernetes.io/master-kubectl taint nodes --all node-role.kubernetes.io/master-

install -o 1000 -d /home/$(id -nu 1000)/.kube
install -o 1000 /etc/kubernetes/admin.conf /home/$(id -nu 1000)/.kube/config
