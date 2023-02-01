FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y

RUN apt-get install --no-install-recommends sudo -y && rm -rf /var/lib/apt/lists/*;

RUN adduser --disabled-password --gecos '' ubuntu
RUN adduser ubuntu sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip

# utils
RUN apt install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# golang
RUN wget https://dl.google.com/go/go1.13.8.linux-amd64.tar.gz && \
  tar -xzvf go1.13.8.linux-amd64.tar.gz -C /usr/local && \
  export PATH=$PATH:/usr/local/go/bin && echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc && \
  mkdir $HOME/go && rm go1.13.8.linux-amd64.tar.gz

USER ubuntu

ENV PATH="${PATH}:/usr/local/go/bin"
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN echo 'PATH="$(python3.6 -m site --user-base)/bin:${PATH}"' >> ~/.bashrc
RUN echo "alias pip=pip3" >> ~/.bashrc

ENTRYPOINT [ "/bin/bash"]

