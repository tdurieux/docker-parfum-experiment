FROM ubuntu:focal

ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update                   \
    && apt-get upgrade --yes \
    && apt-get install --no-install-recommends --yes \
                        build-essential \
                        git \
                        python \
                        python3-pip && rm -rf /var/lib/apt/lists/*;

RUN    git clone 'https://github.com/z3prover/z3' --branch=z3-4.8.15 \
    && cd z3                                                         \
    && python scripts/mk_make.py                                     \
    && cd build                                                      \
    && make -j8                                                      \
    && make install                                                  \
    && cd ../..                                                      \
    && rm -rf z3

COPY kframework_amd64_focal.deb /kframework_amd64_focal.deb
RUN apt-get update                                     \
    && apt-get upgrade --yes \
    && apt-get install --yes --no-install-recommends /kframework_amd64_focal.deb && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /kframework_amd64_focal.deb

COPY pyk/ /pyk
RUN pip3 install --no-cache-dir /pyk \
    && rm -rf /pyk
