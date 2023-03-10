FROM docker:18.01.0-ce-rc1-dind

# Install Python3
RUN apk add --update --no-cache \
    gcc musl-dev libffi-dev \
    build-base linux-headers \
    python3-dev && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache-dir --upgrade pip setuptools && \
    rm -r /root/.cache

# Install necessary python libs
RUN pip3 install --no-cache-dir \
    tqdm docker boto3 werkzeug \
    ujson cffi psutil eel

# Install rust
RUN apk add --update --no-cache \
    libffi-dev py3-psycopg2

ENV PYTHONPATH=/battlecode/battlecode/python

# rest of build is done in scripts/managerbuild.sh

