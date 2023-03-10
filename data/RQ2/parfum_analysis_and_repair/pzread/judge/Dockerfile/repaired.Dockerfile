FROM ubuntu:18.04
ARG TRAVIS_COMMIT
ENV TRAVIS_COMMIT $TRAVIS_COMMIT

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3.6 \
    python3-pip \
    clang \
    gcc \
    g++ \
    cmake \
    libcgroup-dev \
    git \
    sudo \
    acl && rm -rf /var/lib/apt/lists/*;

RUN if [ "${TRAVIS_COMMIT}" ]; then \
    mkdir judge && \
    cd judge && \
    git init && \
    git remote add origin https://github.com/pzread/judge.git && \
    git fetch origin && \
    git fetch origin ${TRAVIS_COMMIT} && \
    git reset --hard FETCH_HEAD; \
    else \
    git clone https://github.com/pzread/judge.git; fi

RUN cd judge && \
    pip3 install --no-cache-dir -r requirements.txt && \
    mkdir lib && \
    cd lib && \
    cmake .. && \
    make
