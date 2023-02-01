ARG FROM=debian:bullseye
FROM ${FROM}

RUN \
  echo "debconf debconf/frontend select Noninteractive" | \
    debconf-set-selections

ARG DEBUG

RUN \
  quiet=$([ "${DEBUG}" = "yes" ] || echo "-qq") && \
  apt update ${quiet} && \
  apt install --no-install-recommends -y -V ${quiet} \
    wget && \
  wget https://packages.groonga.org/debian/groonga-apt-source-latest-bullseye.deb && \
  apt install --no-install-recommends -y -V ${quiet} ./groonga-apt-source-latest-bullseye.deb && \
  rm ./groonga-apt-source-latest-bullseye.deb && \
  apt update ${quiet} && \
  apt install --no-install-recommends -y -V ${quiet} \
    build-essential \
    debhelper \
    devscripts \
    libgroonga-dev \
    pkg-config && \
  apt clean && rm -rf /var/lib/apt/lists/*;
