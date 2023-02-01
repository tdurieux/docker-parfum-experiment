# -*- aggressive-indent-mode: nil -*-

FROM ubuntu:xenial

ADD requirements.txt requirements.txt

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    python \
    python-dev \
    python-pip \
    python-virtualenv \
    python-numpy \
    python-pandas \
    texlive texlive-latex-extra \
    graphviz \
    gosu && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -r requirements.txt

ADD docker/entry.sh entry.sh
ADD docker/main.sh main.sh
VOLUME /data
WORKDIR /data
ENTRYPOINT ["/entry.sh"]
