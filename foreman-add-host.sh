
hammer host delete --name subject.foo.local

hammer host create \
  --name="subject" \
  --domain="foo.local" \
  --build="true" \
  --hostgroup="base" \
  --environment="production" \
  --interface="mac=02:E3:F0:C6:7D:8E,ip=10.0.30.20,subnet_id=1,type=interface,managed=true,primary=true,provision=true" \
  --interface="mac=02:8F:4B:18:68:35,ip=10.0.40.20,subnet_id=2,type=interface,managed=true"        

hammer host info --name subject.foo.local

