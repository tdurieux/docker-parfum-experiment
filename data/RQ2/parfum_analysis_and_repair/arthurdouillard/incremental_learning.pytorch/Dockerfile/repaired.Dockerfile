FROM nvidia/cuda:8.0-runtime-ubuntu16.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository universe && \
    add-apt-repository multiverse && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install python3-pip python3-dev python3-tk vim wget git && \
    pip3 install --no-cache-dir --upgrade pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

ENV TERM xterm
ENV ZSH_THEME flazz

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y zsh && \
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt && \
    rm requirements.txt
