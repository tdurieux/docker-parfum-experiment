FROM ubuntu:16.04

RUN apt-get -y update && apt-get -y --no-install-recommends install git wget python-dev python3-dev libopenmpi-dev python-pip zlib1g-dev cmake python-opencv && rm -rf /var/lib/apt/lists/*;
ENV CODE_DIR /root/code
ENV VENV /root/venv

RUN \
    pip install --no-cache-dir virtualenv && \
    virtualenv $VENV --python=python3 && \
    . $VENV/bin/activate && \
    pip install --no-cache-dir --upgrade pip

ENV PATH=$VENV/bin:$PATH

COPY . $CODE_DIR/baselines
WORKDIR $CODE_DIR/baselines

# Clean up pycache and pyc files
RUN rm -rf __pycache__ && \
    find . -name "*.pyc" -delete && \
    pip install --no-cache-dir tensorflow && \
    pip install --no-cache-dir -e .[test]


CMD /bin/bash
