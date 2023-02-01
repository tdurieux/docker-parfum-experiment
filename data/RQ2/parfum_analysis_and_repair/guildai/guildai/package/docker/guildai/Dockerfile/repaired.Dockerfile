FROM ubuntu:18.04

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update --assume-yes \
    && apt-get install -y --no-install-recommends --assume-yes \
        wget \
        unzip \
        python3 \
        python3-pip \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 2 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 2 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --pre guildai \
    && pip install --no-cache-dir virtualenv --upgrade

WORKDIR /root

RUN wget --quiet https://github.com/guildai/guildai/archive/master.zip \
    && unzip master.zip \
    && mv guildai-master/examples guild-examples \
    && rm -rf guildai-master \
    && rm master.zip

CMD [ "/bin/bash" ]
