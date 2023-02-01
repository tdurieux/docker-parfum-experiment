FROM ubuntu:xenial

# Required for non-interactive installation of gnome-shell
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y python-pip gnome-shell && \
    pip install --no-cache-dir ansible && rm -rf /var/lib/apt/lists/*;

COPY . /home/ubuntu/ubuntu-ansible
WORKDIR /home/ubuntu/ubuntu-ansible

RUN ansible-playbook -i local.inventory setup_gnome.yml
