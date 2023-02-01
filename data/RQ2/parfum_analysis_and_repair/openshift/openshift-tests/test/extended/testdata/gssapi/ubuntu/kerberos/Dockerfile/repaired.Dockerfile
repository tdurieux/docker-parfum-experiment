FROM gssapiproxy/ubuntu-gssapi-base

ENV CLIENT CLIENT_HAS_LIBS

RUN apt-get install --no-install-recommends -y krb5-user && rm -rf /var/lib/apt/lists/*;
