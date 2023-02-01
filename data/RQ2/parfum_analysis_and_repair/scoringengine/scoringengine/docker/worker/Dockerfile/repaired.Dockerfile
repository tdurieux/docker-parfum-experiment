FROM scoringengine/base

USER root

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;

# ICMP Check
RUN apt-get install --no-install-recommends -y iputils-ping && rm -rf /var/lib/apt/lists/*;

# HTTP/S Check
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# MySQL Check
RUN apt-get install --no-install-recommends -y mysql-client && rm -rf /var/lib/apt/lists/*;

# LDAP Check
RUN apt-get install --no-install-recommends -y ldap-utils && rm -rf /var/lib/apt/lists/*;

# VNC Check
RUN apt-get install --no-install-recommends -y medusa && rm -rf /var/lib/apt/lists/*;

# SSH Check
RUN pip install --no-cache-dir -I "cryptography>=3.4,<3.5"
RUN pip install --no-cache-dir "paramiko>=2.7,<2.8"

# WinRM Check
RUN pip install --no-cache-dir -I "pywinrm>=0.4.1,<0.4.2"

# Elasticsearch Check
RUN pip install --no-cache-dir -I "requests>=2.21,<2.22"

# SMB Check
RUN pip install --no-cache-dir -I "pysmb>=1.1,<1.2"

# DNS Check
RUN apt-get install --no-install-recommends -y dnsutils && rm -rf /var/lib/apt/lists/*;

# Postgresql Check
RUN apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

# MSSQL Check
RUN \
  curl -f -s https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
  # Package Repo for Ubuntu 16.04
  curl -f -s https://packages.microsoft.com/config/ubuntu/18.04/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
  # Package Repo for Debian 9 (Docker Hub Python Image)
  # echo "deb [arch=amd64] https://packages.microsoft.com/debian/9/prod "stretch" main" >> /etc/apt/sources.list.d/msprod.list && \
  apt-get update && \
  ACCEPT_EULA=Y apt-get --no-install-recommends install -y \
    locales \
    mssql-tools \
    unixodbc-dev && \
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
  locale-gen && rm -rf /var/lib/apt/lists/*;

# RDP Check
RUN apt-get install --no-install-recommends -y freerdp-x11 && rm -rf /var/lib/apt/lists/*;

# NFS Check
RUN apt-get install --no-install-recommends -y libnfs-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -I "libnfs==1.0.post4"

# Telnet Check
RUN pip install --no-cache-dir -I "telnetlib3==1.0.1"

# OpenVPN Check
RUN apt-get install --no-install-recommends -y openvpn iproute2 sudo && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*

COPY bin/worker /app/bin/worker
COPY docker/worker/sudoers /etc/sudoers

USER engine

COPY scoring_engine /app/scoring_engine
RUN pip install --no-cache-dir -e .

CMD ["./wait-for-port.sh", "redis:6379", "/app/bin/worker"]
