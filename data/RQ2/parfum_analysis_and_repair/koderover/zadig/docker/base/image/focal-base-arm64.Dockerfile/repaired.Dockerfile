FROM arm64v8/ubuntu:focal

RUN sed -i -E "s/[a-zA-Z0-9]+.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y \
  curl \
  git \
  netcat-openbsd \
  wget \
  build-essential \
  libfontconfig \
  libsasl2-dev \
  libfreetype6-dev \
  libpcre3-dev \
  pkg-config \
  cmake \
  python \
  librrd-dev \
  sudo && rm -rf /var/lib/apt/lists/*;

# timezone modification
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# install docker client
RUN curl -fsSL "https://resources.koderover.com/docker-cli-v19.03.2.tar.gz" -o docker.tgz && \
    tar -xvzf docker.tgz && \
    mv docker/* /usr/local/bin && rm docker.tgz

# replace tar（compatible for cephfs）
RUN rm /bin/tar && curl -fsSL https://resource.koderover.com/tar -o /bin/tar && chmod +x /bin/tar
