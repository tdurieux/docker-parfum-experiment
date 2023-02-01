FROM python:3.7-slim-buster

# Upgrade System and Install dependencies
RUN apt-get update && \
  apt-get upgrade -y -o DPkg::Options::=--force-confold && \
  apt-get install --no-install-recommends -y -o DPkg::Options::=--force-confold curl netcat && rm -rf /var/lib/apt/lists/*;

# Install Latest Salt from the stable Branch
RUN curl -f -L https://bootstrap.saltstack.com | sh -s -- -x python3 stable latest

# Set master
COPY saltconfig/etc/minion /etc/salt/minion

COPY utils/entrypoint-minion.sh .

ENTRYPOINT ["./entrypoint-minion.sh"]
