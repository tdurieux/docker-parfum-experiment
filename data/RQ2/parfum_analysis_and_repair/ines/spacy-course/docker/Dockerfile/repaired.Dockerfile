FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends --yes \
        build-essential \
        gcc \
        git \
        python3-pip \
        curl \
        locales \
        musl-dev && rm -rf /var/lib/apt/lists/*;

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

RUN pip3 --no-cache-dir install -U pip
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

COPY package*.json /npm_packages/
COPY binder/requirements.txt /python_binder_requirements/

RUN npm install -g gatsby-cli && npm cache clean --force;
RUN npm install /npm_packages/ && npm cache clean --force;

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10

RUN pip install --no-cache-dir -r /python_binder_requirements/requirements.txt

WORKDIR /host
