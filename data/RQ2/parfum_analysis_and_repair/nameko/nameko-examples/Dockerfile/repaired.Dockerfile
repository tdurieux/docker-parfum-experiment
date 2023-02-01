FROM python:3.7-slim-stretch as base

RUN apt-get update && \
    apt-get install --no-install-recommends --yes curl netcat && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir virtualenv

RUN virtualenv -p python3 /appenv

ENV PATH=/appenv/bin:$PATH

RUN groupadd -r nameko && useradd -r -g nameko nameko

RUN mkdir /var/nameko/ && chown -R nameko:nameko /var/nameko/

# ------------------------------------------------------------------------

FROM nameko-example-base as builder

RUN apt-get update && \
    apt-get install --no-install-recommends --yes build-essential autoconf libtool pkg-config \
    libgflags-dev libgtest-dev clang libc++-dev automake git libpq-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir auditwheel

COPY . /application

ENV PIP_WHEEL_DIR=/application/wheelhouse
ENV PIP_FIND_LINKS=/application/wheelhouse
