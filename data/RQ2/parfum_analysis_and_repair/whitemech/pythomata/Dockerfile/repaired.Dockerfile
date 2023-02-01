FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y dialog && \
    apt-get install --no-install-recommends -y apt-utils && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y gcc && \
    apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;

# This adds the `default` user in to sudoers with full privileges:
RUN HOME=/home/default && \
    mkdir -p ${HOME} && \
    GROUP_ID=1000 && \
    USER_ID=1000 && \
    groupadd -r default -f -g "$GROUP_ID" && \
    useradd -u "$USER_ID" -r -g default -d "$HOME" -s /sbin/nologin \
        -c "Default Application User" default && \
    chown -R "$USER_ID:$GROUP_ID" ${HOME} && \
    usermod -a -G sudo default && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN apt-get install --no-install-recommends -y vim && \
    apt-get install --no-install-recommends -y make && \
    apt-get install --no-install-recommends -y cmake && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y libssl-dev && \
    apt-get install --no-install-recommends -y python3 && \
    apt-get install --no-install-recommends -y python-pip && \
    apt-get install --no-install-recommends -y python3-pip && \
    python -m pip install --upgrade pip && \
    python -m pip install --upgrade cldoc && \
    python -m pip install jupyter && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/default

RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends graphviz -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -f -y

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN pip3 install --no-cache-dir pipenv

USER default

WORKDIR /build
CMD ["/bin/bash"]
