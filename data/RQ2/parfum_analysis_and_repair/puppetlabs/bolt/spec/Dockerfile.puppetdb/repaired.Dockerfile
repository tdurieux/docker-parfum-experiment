FROM puppet/puppetdb:7.2.0

# Use our own certs so this doesn't have to wait for puppetserver startup
COPY fixtures/ssl/ca.pem /opt/puppetlabs/server/data/puppetdb/certs/certs/ca.pem
COPY fixtures/ssl/cert.pem /opt/puppetlabs/server/data/puppetdb/certs/certs/server.crt
COPY fixtures/ssl/key.pem /opt/puppetlabs/server/data/puppetdb/certs/private_keys/pdb.pem
COPY fixtures/ssl/key.pem /opt/puppetlabs/server/data/puppetdb/certs/private_keys/server.key
COPY fixtures/ssl/crl.pem /opt/puppetlabs/server/data/puppetdb/certs/ca/ca_crl.pem