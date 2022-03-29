#! /bin/bash
sudo swapoff -a
sudo apt-get update
apt install -y docker.io
sudo apt-get install -y apt-transport-https ca-certificates curl
#Install the Google cloud package
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# Add repository to the /etc/apt/source.list.d
echo "deb  https://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list
# C group
cat <<EOF | sudo tee /etc/docker/daemon.json
{ "exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts":
{ "max-size": "100m" },
"storage-driver": "overlay2"
}
EOF
apt update && apt install -y kubeadm kubectl kubelet
apt-mark hold kubectl kubeadm kubelet
kubeadm init --pod-network-cidr=10.244.0.0/24
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
