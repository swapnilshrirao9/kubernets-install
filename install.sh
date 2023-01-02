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
