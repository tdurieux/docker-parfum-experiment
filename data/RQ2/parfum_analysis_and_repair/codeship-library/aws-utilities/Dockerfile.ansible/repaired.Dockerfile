FROM ubuntu:18.04

ENV LANG=C.UTF-8

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends python3-setuptools python3-pip apt-transport-https ca-certificates wget rsync unzip jq zip curl && \
  pip3 install --no-cache-dir --upgrade pip && \
  pip3 install --no-cache-dir wheel && \
  pip3 install --no-cache-dir ansible==2.8.20 pyasn1==0.4.8 ndg-httpsclient==0.5.1 urllib3==1.26.3 awscli && rm -rf /var/lib/apt/lists/*;

RUN mkdir /root/bin

COPY tasks /aws/tasks
COPY site.yml site.yml
COPY deployment /aws/deployment

RUN ansible-playbook -i localhost -c local site.yml

ENV PATH="/root/bin:${PATH}"
ENV CODESHIP_VIRTUALENV="/root/.codeship-venv"
