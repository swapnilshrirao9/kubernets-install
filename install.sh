#! /bin/bash
sudo swapoff -a
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
#Install the Google cloud package
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add-
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
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.2.0/cri-dockerd-v0.2.0-linux-amd64.tar.gz
sudo mv ./cri-dockerd /usr/local/bin/ 
cri-dockerd --help
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket
sudo mv cri-docker.socket cri-docker.service /etc/systemd/system/
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
systemctl daemon-reload
systemctl enable cri-docker.service
systemctl enable --now cri-docker.socket
systemctl status cri-docker.socket

apt update && apt install -y kubeadm kubectl kubelet
apt-mark hold kubectl kubeadm kubelet
kubeadm token create --print-join-command
mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml  
# issue in node
kubeadm reset -f
rm -rf /var/lib/cni
systemctl status kubelet
systemctl restart kubelet
systemctl status kubelet
rm -R /etc/systemd/system/kubelet.service.d 
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
systemctl daemon-reload
