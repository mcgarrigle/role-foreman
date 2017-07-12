
hammer medium create --name local --operatingsystem-ids 1 --os-family Redhat --path http://foreman.foo.local:81/centos
hammer os add-config-template --id 1 --config-template "Kickstart default"
hammer os add-ptable --id 1 --partition-table "Kickstart default" 
