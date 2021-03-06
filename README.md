Foreman Role for Laboratory
===========================

Features:
---------

* Foreman
* Puppet 4.0
* PuppetDB
* PostgreSQL
* CentOS 7 local repository

Example implementation:
-----------------------

```
                            { intertubes } 10.0.40.1
                                   |
             10.0.40.X             |
  |----------+-------------+-------+-----|  10.0.40.0/24 (vbox natnetwork)
             |             |               
      enp0s8 |             |               
      +------+----+  +-----+-----+                 
      |  foreman  |  |  guest1   |
      +------+----+  +-----+-----+
      enp0s3 |             |     
             |             |    
  |----------+-------------+-------------|  10.0.30.0/24 (vbox hostonly)
             10.0.30.X
```

Prerequisites:
--------------

* CentOS 7.X VM
* 4G RAM
* 50G Hard Disk (20G minimum)
* Network topology as above

Instructions:
-------------

```
# yum install -y "http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm"
# yum install facter
```

Log out and back in again, then:

```
# ./10-foreman-install.sh
# ./20-foreman-proxy.sh
# ./30-foreman-centos.sh {path to CentOS ISO}
```

If you are integrating with an IPA/IdM realm then look at:

```
# ./40-realm-proxy.sh
```

