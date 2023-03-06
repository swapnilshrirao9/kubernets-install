#docker install 
wget -qO- https://get.docker.com/ | sh
ctr plugin ls
kubeadm certs check-expiration
kubeadm int phase certs front-proxy-ca
kubeadm init phase certs ca 
sudo systemctl daemon-reload
#Error 
sudo systemctl list-unit-files
sudo systemctl unmask docker
 sudo systemctl stop docker
  cp -au /var/lib/docker /var/lib/docker.bk
  sudo systemctl start docker
  137  sudo dockerd --debug
  138  ps -aux | grep docker 
  139  yum remove docker
  140  yum autoremove
  141  sudo systemctl start dockersudo yum install -y yum-utils
  142  sudo yum install -y yum-utils
  143  sudo yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo
  144  sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  145  sudo systemctl start docker
  146  systemctl restart docker
  147  systemctl restart kubelete
  148  systemctl restart kubelet
  149  systemctl status docker
  150  systemctl status kubelet
  151  systemctl enable kubelet
  152  systemctl status kubelet
  153  kubeadm init
  154  kubeadm reset -f
  155  systemctl status kubelet
  156  systemctl enable kubelet
  157  systemctl status kubelet
  158  systemctl start kubelet
  159  systemctl status kubelet
  160  kubelet contents
  161  systemctl stop kubelet
  162  swapoff -a
  163  systemctl start kubelet
  164  systemctl status kubelet
  cat > /etc/containerd/config.toml <<EOF
  [plugins."io.containerd.grpc.v1.cri"]
     systemd_cgroup = true
  EOF
