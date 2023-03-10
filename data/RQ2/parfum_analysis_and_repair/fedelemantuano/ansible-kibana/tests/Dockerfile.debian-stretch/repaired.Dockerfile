FROM debian:stretch

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    libffi-dev \
    libssl-dev \
    python-dev \
    python-pip \
    git \
    systemd \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/elastic/ansible-elasticsearch.git /etc/ansible/roles/elasticsearch

RUN pip install --no-cache-dir --upgrade setuptools && pip install --no-cache-dir ansible

RUN mkdir -p /etc/ansible && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

ENTRYPOINT ["/bin/systemd"]
