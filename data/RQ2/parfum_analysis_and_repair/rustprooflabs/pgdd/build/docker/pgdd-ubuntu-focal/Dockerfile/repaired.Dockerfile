FROM ubuntu:focal

LABEL maintainer="PgDD Project - https://github.com/rustprooflabs/pgdd"

ARG USER=docker
ARG UID=1000
ARG GID=1000
ARG PGXVERSION

RUN useradd -m ${USER} --uid=${UID}


ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y make wget curl gnupg git postgresql-common && rm -rf /var/lib/apt/lists/*;

RUN sh /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y

RUN apt-get update && apt-get upgrade -y --fix-missing
RUN apt-get install --no-install-recommends -y --fix-missing \
        clang-12 llvm-12 clang libz-dev strace pkg-config \
        libxml2 libxml2-dev libreadline8 libreadline-gplv2-dev \
        flex bison libbison-dev build-essential \
        zlib1g-dev libxslt-dev libssl-dev libxml2-utils xsltproc libgss-dev \
        libldap2-dev libkrb5-dev gettext tcl-tclreadline tcl-dev libperl-dev \
        libpython3-dev libprotobuf-c-dev libprotobuf-dev gcc \
        ruby ruby-dev rubygems \
        postgresql-server-dev-10 \
        postgresql-server-dev-11 \
        postgresql-server-dev-12 \
        postgresql-server-dev-13 \
        postgresql-server-dev-14 && rm -rf /var/lib/apt/lists/*;


RUN gem install --no-document fpm


USER ${UID}:${GID}
WORKDIR /home/${USER}

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh
ENV PATH="/home/${USER}/.cargo/bin:${PATH}"

RUN /bin/bash rustup.sh -y \
    && cargo install cargo-pgx --version ${PGXVERSION}

