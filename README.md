A plan to deploy openstack using packstack on a dedicated vm

## How to run

```
kcli create plan
```

## Parameters

|Parameter        |Default Value                                                      |
|-----------------|-------------------------------------------------------------------|
|admin_password   |unix1234                                                           |
|aodh             |False                                                              |
|cluster          |testk                                                              |
|ceilometer       |False                                                              |
|cirros_image     |http://download.cirros-cloud.net/0.5.2/cirros-0.5.2-x86_64-disk.img|
|disk_size        |90                                                                 |
|dns              |8.8.8.8                                                            |
|external_end     |192.168.122.254                                                    |
|external_floating|192.168.122.202                                                    |
|external_gateway |192.168.122.1                                                      |
|external_start   |192.168.122.200                                                    |
|external_subnet  |192.168.122.0/24                                                   |
|interface        |eth0                                                               |
|ironic           |True                                                               |
|lbaas            |True                                                               |
|magnum           |False                                                              |
|manila           |False                                                              |
|memory           |10240                                                              |
|network          |default                                                            |
|numcpus          |4                                                                  |
|ovn              |True                                                               |
|panko            |False                                                              |
|password         |testk                                                              |
|pool             |default                                                            |
|port_security    |False                                                              |
|project          |testk                                                              |
|sahara           |False                                                              |
|swift            |False                                                              |
|trove            |False                                                              |
|user             |testk                                                              |
|version          |yoga                                                               |
|virt_type        |kvm                                                                |
