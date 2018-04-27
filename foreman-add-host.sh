
hammer host delete --name subject.foo.local

hammer host create \
  --name="subject" \
  --domain="foo.local" \
  --build="true" \
  --hostgroup="base" \
  --environment="production" \
  --mac="02:E3:F0:C6:7D:8E" \
  --subnet="management" \
  --ip="10.0.30.20" \
  --interface="name=eth1,mac=02:8F:4B:18:68:35,ip=10.0.40.20,subnet_id=2,type=interface,managed=true"        

hammer host info --name subject.foo.local

# Available keys for --interface:
#  mac
#  ip
#  type                Possible values: interface, bmc, bond, bridge
#  name
#  subnet_id
#  domain_id
#  identifier
#  managed             true/false
#  primary             true/false, each managed hosts needs to have one primary interface.
#  provision           true/false
#  virtual             true/false


