FROM jenkins/jnlp-slave

USER root
RUN apt-get update && \
    apt-get install --no-install-recommends -y unzip wget && rm -rf /var/lib/apt/lists/*;

RUN VERSION=0.17.0; \
    curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    pip install --no-cache-dir lxml && \
    curl -f -SL "https://github.com/facebook/infer/releases/download/v$VERSION/infer-linux64-v$VERSION.tar.xz" \
    | tar -C /opt -xJ && \
    ln -s "/opt/infer-linux64-v$VERSION/bin/infer" /usr/local/bin/infer

RUN echo "deb http://ftp.de.debian.org/debian sid main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;

