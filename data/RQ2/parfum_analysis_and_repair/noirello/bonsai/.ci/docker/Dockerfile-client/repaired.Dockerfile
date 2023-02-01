ARG PYTHON_VERSION=3.7-slim-buster
FROM python:${PYTHON_VERSION}
ARG OPENLDAP_VERSION=2.5.5

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y gcc libssl-dev libffi-dev make curl \
    groff groff-base gdb libsasl2-dev krb5-user iputils-ping libsasl2-modules-gssapi-mit libkrb5-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-${OPENLDAP_VERSION}.tgz | tar xzf -

WORKDIR /openldap-${OPENLDAP_VERSION}
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-tls=openssl --disable-slapd --enable-backends=no
RUN make depend && make && make install

WORKDIR /
RUN apt-get remove -y libldap-2.4-2
RUN python -m pip install -U pip poetry

CMD tail -f /dev/null
WORKDIR /opt/bonsai
