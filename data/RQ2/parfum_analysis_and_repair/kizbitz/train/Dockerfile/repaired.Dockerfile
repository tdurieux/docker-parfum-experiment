# train
FROM python:2.7

MAINTAINER Jerry Baker (kizbitz): 'jbaker@docker.com'

WORKDIR /home/train

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    putty-tools \
    sudo \
    tree \
    vim && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade \
    boto \
    pip \
    requests \
    toml

RUN useradd train && \
    adduser train sudo && \
    echo 'train  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN mkdir -p /home/train/bin

COPY . /home/train/
COPY train/configs/bashrc /home/train/.bashrc
RUN chown -R train: /home/train

USER train
ENV HOME /home/train
ENV PATH /home/train/bin:$PATH

ENTRYPOINT ["/bin/bash"]
