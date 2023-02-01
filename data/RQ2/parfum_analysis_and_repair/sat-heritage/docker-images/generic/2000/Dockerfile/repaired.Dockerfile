ARG BASE
ARG BUILDER_BASE
FROM ${BUILDER_BASE} as builder

RUN apt-get update --fix-missing && \
    apt-get -y --no-install-recommends install gcc make libc6-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /src

ARG SOLVER_NAME
ARG download_url

ADD $download_url /src

COPY ${SOLVER_NAME}.build.sh /src/build.sh

RUN mkdir /dist && bash build.sh
