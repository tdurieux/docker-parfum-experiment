FROM apiaryio/emcc
WORKDIR /work

RUN \
  apt-get update; \
  apt-get install --no-install-recommends -y \
    build-essential \
    clang \
    libxml2-utils \
    zip \
    inotify-tools \
    file \
    unzip \
    pkg-config \
    gcc; rm -rf /var/lib/apt/lists/*;

ADD ./compiler /work

CMD ["bash", "worker.sh"]
