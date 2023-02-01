FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu18.04

RUN apt-get upgrade -y
RUN apt-get update
RUN apt-get install --no-install-recommends -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    wget curl llvm libncursesw5-dev xz-utils libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev apt-utils p7zip unzip \
    git && rm -rf /var/lib/apt/lists/*;

RUN cd /opt
RUN wget https://www.python.org/ftp/python/3.9.12/Python-3.9.12.tgz
RUN tar -xf Python-3.9.12.tgz && rm Python-3.9.12.tgz
RUN cd Python-3.9.12 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
RUN rm Python-3.9.12.tgz
RUN rm -r Python-3.9.12

RUN ln -s /usr/local/bin/python3 /usr/local/bin/python && \
    ln -s /usr/local/bin/pip3 /usr/local/bin/pip

RUN apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*; # Required to install open-cv

WORKDIR /TextBoxGAN
RUN git config --global --add safe.directory /TextBoxGAN

RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir poetry
RUN poetry config virtualenvs.create false
COPY pyproject.toml poetry.lock ./
RUN poetry install
