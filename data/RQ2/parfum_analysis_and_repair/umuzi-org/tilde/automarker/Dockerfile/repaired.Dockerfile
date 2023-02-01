FROM node:14.19

# Install Python3.7
WORKDIR /home/downloads

RUN apt-get update && apt-get install --no-install-recommends -y \
    software-properties-common \
    python-pip \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev wget && rm -rf /var/lib/apt/lists/*;

RUN curl -f -O https://www.python.org/ftp/python/3.9.5/Python-3.9.5.tar.xz
RUN tar -xf Python-3.9.5.tar.xz && rm Python-3.9.5.tar.xz
WORKDIR /home/downloads/Python-3.9.5
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations
RUN make
RUN make altinstall
RUN python3.9 --version

RUN pip install --no-cache-dir virtualenv

# Install Java
RUN echo 'deb http://ftp.debian.org/debian stretch-backports main' | tee /etc/apt/sources.list.d/stretch-backports.list
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install default-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /home/node/app
COPY . .

RUN npm install -g jasmine && npm cache clean --force;
RUN npm install && npm cache clean --force;

ENV CLONE_PATH /clone
# ENV CONFIGURATION_REPO_PATH /home/node/app/project_config
RUN mkdir $CLONE_PATH

ENV AUTO_MARKER_PORT 8080
EXPOSE $AUTO_MARKER_PORT



CMD [ "node", "app.mjs" ]
