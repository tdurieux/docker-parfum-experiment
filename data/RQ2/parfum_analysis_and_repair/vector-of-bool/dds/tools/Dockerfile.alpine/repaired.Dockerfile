FROM alpine:3.15.4

# Base build dependencies
RUN apk add --no-cache "gcc~10.3" "g++~10.3" make python3 py3-pip \
    git openssl-libs-static openssl-dev ccache lld curl python3-dev cmake clang

# We use version-qualified names for compiler executables
RUN ln -s $(type -P gcc) /usr/local/bin/gcc-10 && \
    ln -s $(type -P g++) /usr/local/bin/g++-10

# We want the UID in the container to match the UID on the outside, for minimal
# fuss with file permissions
ARG BPT_USER_UID=1000

RUN curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py \
    | env POETRY_HOME=/opt/poetry python3 -u - --no-modify-path && \
    ln -s /opt/poetry/bin/poetry /usr/local/bin/poetry && \
    chmod a+x /opt/poetry/bin/poetry && \
    adduser --disabled-password --uid=${BPT_USER_UID} bpt

USER bpt
