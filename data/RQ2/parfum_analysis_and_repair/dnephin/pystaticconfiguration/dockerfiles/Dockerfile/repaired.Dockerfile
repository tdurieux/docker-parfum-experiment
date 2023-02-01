FROM    ubuntu:xenial

ENV     LANG C.UTF-8
RUN export DEBIAN_FRONTEND=noninteractive; \
        apt-get update && apt-get install -y --no-install-recommends \
            software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN export DEBIAN_FRONTEND=noninteractive; \
        add-apt-repository ppa:deadsnakes/ppa && \
        apt-get update && apt-get install -y --no-install-recommends \
            python2.6 \
            python2.7 \
            python3.4 \
            python3.5 \
            pypy \
            curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -Ls https://bootstrap.pypa.io/get-pip.py | python3
RUN pip install --no-cache-dir \
            tox \
            yapyautotest

WORKDIR /work
