FROM ubuntu:xenial

RUN apt-get update && apt-get dist-upgrade -y && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*

RUN apt-add-repository -y ppa:ansible/ansible && apt-get update && apt-get install --no-install-recommends -y \
    git \
    ansible \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/elastic/ansible-elasticsearch.git /etc/ansible/roles/elasticsearch

RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

ENTRYPOINT ["/sbin/init"]
