ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3.6 && \
    ln -s /usr/bin/python3.6 /usr/bin/python && rm -rf /var/lib/apt/lists/*;
