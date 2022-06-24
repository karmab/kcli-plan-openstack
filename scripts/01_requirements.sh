echo centos >/etc/yum/vars/contentdir
systemctl disable --now firewalld
systemctl disable --now NetworkManager
systemctl enable --now network
dnf config-manager --enable {{ "powertools" if 'CentOS-Stream-GenericCloud-8' in image else 'crb' }}
dnf update -y
dnf install -y centos-release-openstack-{{ version }}
dnf install -y openstack-packstack wget vim lvm2
pvcreate /dev/vdb
vgcreate cinder-volumes /dev/vdb
