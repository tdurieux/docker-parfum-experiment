# DOCKER-VERSION 1.1.0
FROM    rockylinux:8

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

LABEL org.inginious.grading.agent_version=3

# Install python, needed for scripts used in INGInious + locale support
RUN     dnf clean metadata && \
        dnf -y install langpacks-en && \
        dnf -y install epel-release && \
        dnf -y upgrade && \
        dnf -y install python38 python38-pip python38-devel zip unzip tar sed openssh-server openssl bind-utils iproute file jq procps-ng man curl net-tools screen nano bc  && \
        pip3.8 install msgpack pyzmq jinja2 PyYAML timeout-decorator ipython mypy && \
        dnf clean all

# Allow to run commands
ADD     . /INGInious
RUN     chmod -R 755 /INGInious/bin && \
        chmod 700 /INGInious/bin/INGInious && \
        mv /INGInious/bin/* /bin

# Install everything needed to allow INGInious' python libs to be loaded
RUN     chmod -R 644 /INGInious/inginious_container_api && \
        mkdir -p /usr/lib/python3.8/site-packages/inginious_container_api && \
        cp -R /INGInious/inginious_container_api/*.py  /usr/lib/python3.8/site-packages/inginious_container_api && \
        echo "inginious_container_api" > /usr/lib/python3.8/site-packages/inginious_container_api.pth

# This maintains backward compatibility
RUN     mkdir -p /usr/lib/python3.8/site-packages/inginious && \
        cp -R /INGInious/inginious_container_api/*.py  /usr/lib/python3.8/site-packages/inginious && \
        echo "inginious" > /usr/lib/python3.8/site-packages/inginious.pth

# Delete unneeded folders
RUN     rm -R /INGInious

# Create worker user
RUN     groupadd --gid 4242 worker && \
        useradd --uid 4242 --gid 4242 worker --home-dir /task

# Set locale params for SSH debug
RUN     echo -e "LANG=en_US.UTF-8\nLANGUAGE=en_US:en\nLC_ALL=en_US.UTF-8" >> /etc/environment
RUN     sed -i.bak '/^AcceptEnv/ d' /etc/ssh/sshd_config

CMD ["INGInious"]
