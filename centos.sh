yum update -y

## Install yum-utils, bash completion, git, and more
yum install yum-utils nfs-utils bash-completion git -y

##Disable firewall starting from Kubernetes v1.19 onwards
systemctl disable firewalld --now


## letting ipTables see bridged networks
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

##
## iptables config as specified by CRI-O documentation
# Create the .conf file to load the modules at bootup
#cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
#overlay
#br_netfilter
#EOF


sudo modprobe overlay
sudo modprobe br_netfilter


# Set up required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system


###
## configuring Kubernetes repositories
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

## Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

### Disable swap
swapoff -a

##make a backup of fstab
cp -f /etc/fstab /etc/fstab.bak

##Renove swap from fstab
sed -i '/swap/d' /etc/fstab


##Refresh repo list
yum repolist -y


## Install CRI-O binaries
##########################

#Operating system       $OS
#Centos 8       CentOS_8
#Centos 8 Stream        CentOS_8_Stream
#Centos 7       CentOS_7


#set OS version
OS=CentOS_7

#set CRI-O
#VERSION=1.20

echo Install Docker
curl -fsSL https://test.docker.com -o test-docker.sh
sh test-docker.sh 

yum install -y kubelet-1.26.1-0 kubeadm-1.26.1-0 kubectl-1.26.1-0 --disableexcludes=kubernetes
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --upload-certs --kubernetes-version=v1.26.1 --control-plane-endpoint=192.168.56.200 --cri-socket unix:///run/containerd/containerd.sock >>join.sh
------

#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config
# export KUBECONFIG=/etc/kubernetes/admin.conf
#kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml

