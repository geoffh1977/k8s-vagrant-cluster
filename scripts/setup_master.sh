#!/bin/bash
kubeadm init --apiserver-advertise-address 192.168.77.10 --pod-network-cidr=10.244.0.0/16 --node-name="$(hostname -s)" --apiserver-cert-extra-sans=10.0.2.15

[ ! -d /vagrant/output ] && mkdir -p /vagrant/output

cp -f /etc/kubernetes/admin.conf /vagrant/output/kube.config
kubeadm token create --print-join-command > /vagrant/output/join_cluster.sh

chown vagrant:vagrant /vagrant/output/*
chmod 0755 /vagrant/output/join_cluster.sh
