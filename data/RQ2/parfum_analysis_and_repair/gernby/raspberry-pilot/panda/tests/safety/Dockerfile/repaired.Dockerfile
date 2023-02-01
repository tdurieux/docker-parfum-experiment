FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y clang make python python-pip git curl locales zlib1g-dev libffi-dev bzip2 libssl-dev libbz2-dev libusb-1.0-0 && rm -rf /var/lib/apt/lists/*;

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN curl -f -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:${PATH}"
RUN pyenv install 3.7.3
RUN pyenv global 3.7.3
RUN pyenv rehash

COPY tests/safety/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY . /panda
