#! /bin/bash
sudo swapoff -a
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
#Install the Google cloud package
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# Add repository to the /etc/apt/source.list.d
echo "deb  https://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list
apt update && apt install -y kubeadm kubectl kubelet docker.io
apt-mark hold kubectl kubeadm kubelet
# C group
cat <<EOF | sudo tee /etc/docker/daemon.json
{ "exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts":
{ "max-size": "100m" },
"storage-driver": "overlay2"
}
EOF
kubeadm init --pod-network-cidr=10.244.0.0/24 > OUTPUT.txt
#kubeadm token create --print-join-command
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
reset 
kubeadm reset -f
rm -r $HOME/.kube
sudo kubeadm init --apiserver-advertise-address=182.168.0.100 --pod-network-cidr=192.168.0.0/16
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml

