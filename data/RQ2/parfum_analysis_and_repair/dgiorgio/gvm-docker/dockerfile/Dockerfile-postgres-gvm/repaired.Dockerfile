ARG gvmd_version
ARG postgres_gvm_version

FROM dgiorgio/gvmd:${gvmd_version} AS gvmd
FROM postgres:${postgres_gvm_version}

RUN apt update -y && apt install -y --no-install-recommends --fix-missing \
  git cmake gcc make clang-format pkg-config libglib2.0-dev libgpgme11-dev \
  libgnutls28-dev uuid-dev libssh-gcrypt-dev libldap2-dev libhiredis-dev \
  libfreeradius-dev doxygen xmltoman libxml2-dev libical-dev gnutls-bin \
  doxygen xmltoman xsltproc sqlfairy libsqlite3-dev libpq-dev \
  texlive-latex-base xmlstarlet zip rpm dpkg fakeroot nsis gnupg \
  wget sshpass ssh-client socat snmp smbclient python3 python3-lxml haveged \
  cron libpq-dev postgresql-11 postgresql-server-dev-11 libradcli-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/lib/x86_64-linux-gnu
RUN ln -sf libical.so libical.so.3 \
  && ln -sf libicalss.so libicalss.so.3 \
  && ln -sf libicalvcal.so libicalvcal.so.3 \
  && ln -sf libicuuc.so libicuuc.so.57 \
  && ln -sf libicui18n.so libicui18n.so.57 \
  && ln -sf libgcrypt.so libssh-gcrypt.so.4 \
  && ln -sf libc.so libc.so.6

COPY --from=gvmd /usr/local/lib/libgvm* /usr/local/lib/

WORKDIR /usr/local/lib
RUN chmod -R 644 /usr/local/lib/libgvm* \
  && ldconfig
EXPOSE 5432