FROM debian:stretch

WORKDIR /opt

RUN apt-get update && \
  apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
  git \
  python-dev \
  python-pip \
  screen \
  p7zip-full \
  libjpeg-dev \
  zlib1g-dev \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
   --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
RUN echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"

RUN apt-get update && apt-get install --no-install-recommends -y \
    docker-ce \
    docker-ce-cli \
    containerd.io && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    mongodb-org && rm -rf /var/lib/apt/lists/*;


RUN pip install --no-cache-dir virtualenv && \
    git clone https://github.com/certsocietegenerale/fame

ENTRYPOINT ["/opt/fame/docker/launch.sh"]
EXPOSE 4200
