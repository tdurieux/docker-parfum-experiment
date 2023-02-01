FROM python:3.7-slim-buster

# Upgrade System and Install dependencies
RUN apt-get update && \
  apt-get upgrade -y -o DPkg::Options::=--force-confold && \
  apt-get install --no-install-recommends -y -o DPkg::Options::=--force-confold curl python3-mysqldb netcat && rm -rf /var/lib/apt/lists/*;

# Install Latest Salt from the stable Branch
RUN curl -f -L https://bootstrap.saltstack.com | sh -s -- -X -M -x python3 stable latest

# Set master and id
COPY saltconfig/etc/minion /etc/salt/minion
RUN echo "id: master">>/etc/salt/minion

# Install python dependencies
RUN apt-get install --no-install-recommends -y -o DPkg::Options::=--force-confold salt-api python3-openssl && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir honcho

# Copy needed files
COPY saltconfig/etc/master /etc/salt/master
COPY saltconfig/salt /srv/salt
COPY saltconfig/pillar /srv/pillar
COPY utils/wait-for .
COPY utils/Procfile .
COPY utils/entrypoint-master.sh .

# Sync auth and returners
RUN salt-run saltutil.sync_all

# Create salt-api certs
RUN salt-call --local tls.create_self_signed_cert cacert_path='/etc/pki'

ENTRYPOINT ["./entrypoint-master.sh"]
