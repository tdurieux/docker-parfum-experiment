FROM n42org/tox
MAINTAINER Matías Aguirre <matiasaguirre@gmail.com>
RUN apt-get update && apt-get install --no-install-recommends -y make libssl-dev libxml2-dev libxmlsec1-dev mongodb-server mongodb-dev swig openssl && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/include/x86_64-linux-gnu/openssl/opensslconf.h /usr/include/openssl/opensslconf.h
