# Dockerfile for hyperledger cello ansible agent
#
# @see https://github.com/hyperledger/cello/blob/master/docs/worker_ansible_howto.md
#
FROM python:3.6
MAINTAINER Hyperledger Cello Team <github.com/hyperledger/cello>

ARG user=ubuntu
ARG uid=1000
ARG gid=1000

RUN apt-get update && \
    apt-get install --no-install-recommends -y bash curl python-dev sudo \
    python3-pip build-essential openssh-client libffi-dev \
    libssl-dev && \
    pip install --no-cache-dir --upgrade pip ansible pyyaml && \
    groupadd -g ${gid} ${user} && \
    useradd -d /opt/agent -u ${uid} -g ${user} ${user} && \
    usermod -a -G root ${user} && \
    echo "${user} ALL=(ALL) NOPASSWD: ALL"|tee /etc/sudoers.d/${user} && \
    mkdir -p /opt/agent/.ssh && \
    cd /opt/agent/.ssh && \
    echo "host *" > config && \
    echo "  StrictHostKeyChecking no" >> config && \
    echo "  UserKnownHostsFile /dev/null" >> config && rm -rf /var/lib/apt/lists/*;

ADD src/agent/ansible /opt/agent
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    mv kubectl /usr/local/bin/kubectl
RUN chown -R ${uid}:${gid} /opt/agent                       && \
    chmod 755 /usr/local/bin/kubectl

ENV HOME /opt/agent
ENV WORKDIR /opt/agent
WORKDIR /opt/agent
USER ${user}

CMD [ "ansible-playbook", "--version" ]
