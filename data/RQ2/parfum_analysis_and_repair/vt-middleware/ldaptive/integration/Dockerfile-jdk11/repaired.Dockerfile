FROM maven:3.8-openjdk-11
RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install --no-install-recommends -y net-tools ldap-utils krb5-user && \
  rm -rf /var/lib/apt/lists/*
