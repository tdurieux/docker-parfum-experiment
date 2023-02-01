ARG TAG=latest
FROM cribl/cribl:$TAG

ADD groups /var/opt/cribl/groups
ADD local /var/opt/cribl/local
ADD scripts /var/opt/cribl/scripts
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt-get install -y docker.io

