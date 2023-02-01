FROM python:3.5-slim-stretch

RUN apt-get update && apt-get install -y \
    libffi-dev \
    g++ \
    python3-dev \
    libmemcached-dev \
    libz-dev

COPY . /wikilabels
WORKDIR /wikilabels

RUN pip install pip --upgrade
RUN pip install wheel
RUN pip install -r /wikilabels/requirements.txt
RUN pip install pytest flake8 codecov pytest-cov pytest-flask

ENTRYPOINT ./utility dev_server
EXPOSE 8080
