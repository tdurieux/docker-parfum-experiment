FROM ubuntu:16.04

RUN apt-get -y update && apt-get -y --no-install-recommends install git wget python-dev python3-dev libopenmpi-dev python-pip zlib1g-dev cmake && rm -rf /var/lib/apt/lists/*;
ENV CODE_DIR /root/code
ENV VENV /root/venv

COPY . $CODE_DIR/baselines
RUN \
    pip install --no-cache-dir virtualenv && \
    virtualenv $VENV --python=python3 && \
    . $VENV/bin/activate && \
    cd $CODE_DIR && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -e baselines && \
    pip install --no-cache-dir pytest

ENV PATH=$VENV/bin:$PATH
WORKDIR $CODE_DIR/baselines

CMD /bin/bash
