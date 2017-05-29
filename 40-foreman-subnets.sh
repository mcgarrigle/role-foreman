

hammer subnet create --name "CLUSTER" \
--boot-mode "Static" \
--network "10.0.30.0" \
--mask "255.255.255.0" \
--from "10.0.30.200" \
--to "10.0.30.250" \
--domains "foo.local" \
--ipam "None" 
