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
