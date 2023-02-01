FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y python-virtualenv && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN virtualenv -p python3 /root/venv \
    && . /root/venv/bin/activate \
    && curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python get-pip.py \
    && python -m pip install -U pip

RUN virtualenv -p python2 /root/venv2 \
    && . /root/venv2/bin/activate \
    && curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python get-pip.py \
    && python -m pip install -U pip
