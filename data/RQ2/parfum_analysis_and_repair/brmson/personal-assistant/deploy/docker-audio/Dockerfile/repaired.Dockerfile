FROM debian:8

MAINTAINER Pavel Trutman <pavel.trutman@fel.cvut.cz>

RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-utils \
                       debconf-utils && rm -rf /var/lib/apt/lists/*;

# Pulseaudio
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y pulseaudio && \
    echo enable-shm=no >> /etc/pulse/client.conf && rm -rf /var/lib/apt/lists/*;
ENV PULSE_SERVER /run/pulse/native
# env PULSE_COOKIE won't work with ro binding
RUN mkdir -p ~/.config/pulse && ln -sf /run/pulse/cookie ~/.config/pulse/cookie

# Git
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git && rm -rf /var/lib/apt/lists/*;

# Ansible
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y ansible && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

# clone application
RUN git clone --depth 5 https://github.com/brmson/Personal-Assistant.git

# provision with ansible
RUN ansible-playbook -c local -i Personal-Assistant/deploy/ansible/docker_hosts Personal-Assistant/deploy/ansible/docker-audio.yml

# set entrypoint
CMD ["python3", "/root/run.py"]
