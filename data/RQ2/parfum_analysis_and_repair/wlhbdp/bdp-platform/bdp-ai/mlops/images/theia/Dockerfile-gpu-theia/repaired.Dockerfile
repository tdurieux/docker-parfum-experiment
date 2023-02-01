# docker build -t ccr.ccs.tencentyun.com/cube-studio/notebook:vscode-ubuntu-gpu-theia -f Dockerfile-gpu-theia .
# docker run --name gpu --rm -it --user root -p 3000:3000 ccr.ccs.tencentyun.com/cube-studio/notebook:vscode-ubuntu-gpu-theia bash

ARG NODE_VERSION=12.18.3
FROM ccr.ccs.tencentyun.com/cube-studio/theia-python

FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

# Install Python 3 from source
ARG VERSION=3.8.3

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y make build-essential libssl-dev \
    && apt-get install --no-install-recommends -y libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libncurses5-dev libncursesw5-dev xz-utils && rm -rf /var/lib/apt/lists/*;
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
RUN echo "Asia/Shanghai" > /etc/timezone && apt-get install -y --no-install-recommends tk-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz \
    && tar xvf Python-$VERSION.tgz \
    && cd Python-$VERSION \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make -j8 \
    && make install \
    && cd .. \
    && rm -rf Python-$VERSION \
    && rm Python-$VERSION.tgz

RUN apt-get update \
    && apt-get install --no-install-recommends -y python-dev python-pip \
    && pip install --no-cache-dir --upgrade pip --user \
    && apt-get install --no-install-recommends -y python3-dev python3-pip \
    && pip3 install --no-cache-dir --upgrade pip --user \
    && pip3 install --no-cache-dir python-language-server flake8 autopep8 \
    && apt-get install --no-install-recommends -y yarn \
    && apt-get clean \
    && apt-get auto-remove -y \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /home/theia && mkdir -p /home/project
ENV HOME /home/theia
WORKDIR /home/theia
COPY --from=0 /home/theia /home/theia
EXPOSE 3000
ENV SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=local-dir:/home/theia/plugins
ENV USE_LOCAL_GIT true
ENTRYPOINT [ "node", "/home/theia/src-gen/backend/main.js", "/home/project", "--hostname=0.0.0.0" ]
