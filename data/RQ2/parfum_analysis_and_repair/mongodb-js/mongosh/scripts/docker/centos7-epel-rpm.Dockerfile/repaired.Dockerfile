FROM centos:7

ARG artifact_url=""
ADD ${artifact_url} /tmp
ADD node_modules /usr/share/mongodb-crypt-library-version/node_modules
RUN yum repolist
# epel-release so that openssl11 is installable
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum repolist
RUN yum install -y /tmp/*mongosh*.rpm && rm -rf /var/cache/yum
RUN /usr/bin/mongosh --build-info
RUN env MONGOSH_RUN_NODE_SCRIPT=1 mongosh /usr/share/mongodb-crypt-library-version/node_modules/.bin/mongodb-crypt-library-version /usr/lib64/mongosh_crypt_v1.so | grep -Eq '^mongo_(crypt|csfle)_v1-'
ENTRYPOINT [ "mongosh" ]
