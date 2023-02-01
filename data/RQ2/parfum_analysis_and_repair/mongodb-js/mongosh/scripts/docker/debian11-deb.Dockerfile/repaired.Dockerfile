FROM debian:11

ARG artifact_url=""
ADD ${artifact_url} /tmp
ADD node_modules /usr/share/mongodb-crypt-library-version/node_modules
RUN apt-get update
RUN apt-get install --no-install-recommends -y man-db && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y /tmp/*mongosh*.deb && rm -rf /var/lib/apt/lists/*;
RUN /usr/bin/mongosh --build-info
RUN env MONGOSH_RUN_NODE_SCRIPT=1 mongosh /usr/share/mongodb-crypt-library-version/node_modules/.bin/mongodb-crypt-library-version /usr/lib/mongosh_crypt_v1.so | grep -Eq '^mongo_(crypt|csfle)_v1-'
RUN man mongosh | grep -q tlsAllowInvalidCertificates
ENTRYPOINT [ "mongosh" ]
