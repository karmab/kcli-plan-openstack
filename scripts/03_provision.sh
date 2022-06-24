export ADMIN_PASSWORD="{{ admin_password }}"
export EXTERNAL_SUBNET="{{ external_subnet }}"
export EXTERNAL_START="{{ external_start }}"
export EXTERNAL_END="{{ external_end }}"
export EXTERNAL_GATEWAY="{{ external_gateway }}"
export EXTERNAL_FLOATING="{{ external_floating }}"
cp ~/keystonerc_admin ~/keystonerc_{{ user }}
sed -i "s/OS_USERNAME=admin/OS_USERNAME={{ user }}/" ~/keystonerc_{{ user }}
sed -i "s/OS_PASSWORD=.*/OS_PASSWORD={{ password }}/" ~/keystonerc_{{ user }}
sed -i "s/OS_TENANT_NAME=admin/OS_TENANT_NAME={{ project }}/" ~/keystonerc_{{ user }}
sed -i "s/OS_PROJECT_NAME=admin/OS_PROJECT_NAME={{ project }}/" ~/keystonerc_{{ user }}
sed -i "s/keystone_admin/keystone_{{ user }}/" ~/keystonerc_{{ user }}
source ~/keystonerc_admin
openstack flavor list | grep -q m1.tiny || openstack flavor create --public m1.tiny --id auto --ram 256 --disk 0 --vcpus 1 --rxtx-factor 1
openstack flavor create --id 6 --ram 32768 --vcpus 16 --disk 30 m1.openshift
openstack project create {{ project }}
openstack user create  --project {{ project }} --password {{ password }} {{ user }}
openstack role add --user={{ user }} --project={{ project }} admin
#grep -q 'type_drivers = vxlan' /etc/neutron/plugin.ini && sed -i 's/type_drivers =.*/type_drivers = vxlan,flat/' /etc/neutron/plugin.ini && systemctl restart neutron-server
neutron net-create extnet --provider:network_type flat --provider:physical_network extnet --router:external || neutron net-create extnet --router:external
neutron subnet-create --name ${EXTERNAL_SUBNET} --allocation-pool start=${EXTERNAL_START},end=${EXTERNAL_END} --disable-dhcp --gateway ${EXTERNAL_GATEWAY} extnet ${EXTERNAL_SUBNET}
OLD_PASSWORD=`grep PASSWORD /root/keystonerc_admin | cut -f2 -d'='`
openstack user password set  --original-password ${OLD_PASSWORD} --password ${ADMIN_PASSWORD} || openstack user set --password ${ADMIN_PASSWORD} admin || keystone password-update --new-password ${ADMIN_PASSWORD}
sed -i "s/OS_PASSWORD=.*/OS_PASSWORD=$ADMIN_PASSWORD/" ~/keystonerc_admin
source ~/keystonerc_{{ user }}
curl -L {{ cirros_image }} > /tmp/c.img
glance image-create --name "cirros" --disk-format qcow2 --container-format bare --file /tmp/c.img
tail -1 /root/.ssh/authorized_keys > ~/{{ user }}.pub
nova keypair-add --pub-key ~/{{ user }}.pub {{ user }}
neutron net-create default --
neutron subnet-create --name 11.0.0.0/24 --allocation-pool start=11.0.0.2,end=11.0.0.254 --gateway 11.0.0.1 --dns-nameserver {{ dns }} default 11.0.0.0/24 
neutron router-create router
neutron router-gateway-set router extnet
neutron router-interface-add router 11.0.0.0/24
seq 5 | xargs -I -- neutron floatingip-create extnet
neutron security-group-create {{ user }}
neutron security-group-rule-create --direction ingress --protocol tcp --port_range_min 22 --port_range_max 22 --remote-ip-prefix 0.0.0.0/0 {{ user }}
neutron security-group-rule-create --protocol icmp --direction ingress  --remote-ip-prefix 0.0.0.0/0 {{ user }}
nova boot --flavor m1.tiny --security-groups testk --key-name testk --image cirros --nic net-id=`neutron net-show default -c id -f value` {{ user }}
sleep 8
ip=$(neutron floatingip-list -f value -c floating_ip_address | head -1) ; openstack server add floating ip {{ user }} ${ip}
projectid=$(openstack project show {{ project }} -f value -c id)
openstack quota set --instances -1 --cores -1 --ram -1 --volumes -1 $projectid
