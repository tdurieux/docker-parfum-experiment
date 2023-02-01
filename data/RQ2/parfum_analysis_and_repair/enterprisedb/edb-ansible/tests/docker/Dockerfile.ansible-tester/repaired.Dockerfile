FROM debian:10-slim

RUN apt update
RUN apt install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip openssh-client build-essential && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pip --upgrade
RUN pip3 install --no-cache-dir ansible-core >=2.11
RUN pip3 install --no-cache-dir paramiko
RUN pip3 install --no-cache-dir pytest-testinfra
RUN pip3 install --no-cache-dir pyyaml
RUN ansible-galaxy collection install community.postgresql:=1.6.0
RUN ansible-galaxy collection install ansible.posix:=1.3.0
RUN ansible-galaxy collection install community.general:=2.5.8
RUN ansible-galaxy collection install community.crypto:=1.9.12
