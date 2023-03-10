FROM python:3.7.7-stretch

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        build-essential \
        python3 python3-dev python3-pip python3-setuptools python3-venv \
        swig portaudio19-dev libatlas-base-dev \
        fakeroot && rm -rf /var/lib/apt/lists/*;