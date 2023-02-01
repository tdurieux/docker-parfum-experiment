FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update
RUN apt-get install --no-install-recommends -y --reinstall \
    software-properties-common \
    ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y 'ppa:deadsnakes/ppa'
RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends --fix-missing -y \
    curl \
    python3.6-dev \
    python3.7-dev \
    python3.8-dev \
    python3.9-dev \
    python3.10-dev \
    python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade pip

RUN python3 -m pip install tox
RUN curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3
ENV PATH "/root/.poetry/bin:$PATH"

RUN mkdir src
WORKDIR /src

CMD tox --parallel all
