# Run tests inside docker without requiring full installation of dependencies on local machine
# Simply run "docker build -f Dockerfile_test ."
# WARNING: sometimes it fails with a core dumped exception

FROM node:10-stretch

RUN apt-get -qq update \
&& DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
    apt-transport-https \
    curl \
    unzip \
    build-essential \
    python \
    libcairo2-dev \
    libgles2-mesa-dev \
    libgbm-dev \
    libllvm3.9 \
    libprotobuf-dev \
    libxxf86vm-dev \
    xvfb \
&& apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN wget -O test_data.zip https://github.com/maptiler/tileserver-gl/releases/download/v1.3.0/test_data.zip
RUN unzip -q test_data.zip -d test_data

ENV NODE_ENV="test"

COPY package.json .
RUN npm install && npm cache clean --force;
COPY / .
RUN xvfb-run --server-args="-screen 0 1024x768x24" npm test
