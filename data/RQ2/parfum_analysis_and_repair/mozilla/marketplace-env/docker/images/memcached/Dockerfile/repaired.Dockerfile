FROM mozillamarketplace/centos-python27-mkt:latest

RUN yum install -y memcached && rm -rf /var/cache/yum

EXPOSE 11211
