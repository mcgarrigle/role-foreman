
ipa privilege-add 'Smart Proxy Host Management' --desc='Smart Proxy Host Management'

# Create the permissions needed to update one-time passwords and the userclass:

ipa permission-add 'modify host password' --permissions='write' --type='host' --attrs='userpassword'
ipa permission-add 'write host certificate' --permissions='write' --type='host' --attrs='usercertificate'
ipa permission-add 'modify host userclass' --permissions='write' --type='host' --attrs='userclass'

# Add the permissions to the privilege:

ipa privilege-add-permission 'Smart Proxy Host Management' --permission='add hosts' \
 --permission='remove hosts' --permission='modify host password' --permission='modify host userclass' \
 --permission='modify hosts' --permission='revoke certificate' --permission='manage host keytab' \
 --permission='write host certificate' --permissions='retrieve certificates from the ca' \
 --permissions='modify services' --permissions='manage service keytab' \
 --permission='read dns entries' --permission='remove dns entries' \
 --permission='add dns entries' --permission='update dns entries' 

# Create a new role:

ipa role-add 'Smart Proxy Host Manager' --desc='Smart Proxy management'

# Assign the privilege to the role:

ipa role-add-privilege 'Smart Proxy Host Manager' --privilege='Smart Proxy Host Management'

# Create a user in FreeIPA for the proxy to use, such as realm-proxy. Don’t use foreman-proxy or foreman as the username!

ipa user-add realm-proxy --first Smart --last Proxy

# Assign the above created role:

ipa role-add-member 'Smart Proxy Host Manager' --users=realm-proxy

# Get the Keytab for the Realm Proxy User:

ipa-getkeytab -s ipa.foo.local -p realm-proxy@FOO.LOCAL -k freeipa.keytab
