FROM ubuntu:xenial

LABEL maintainer "https://github.com/blacktop"

LABEL malice.plugin.repository = "https://github.com/malice-plugins/pdf.git"
LABEL malice.plugin.category="pdf"
LABEL malice.plugin.mime="application/pdf"
LABEL malice.plugin.docker.engine="*"

ENV PDFID 0_2_4
ENV PDF_PARSER 0_6_8

COPY . /usr/sbin
RUN buildDeps='ca-certificates \
  libboost-system-dev \
  libboost-python-dev \
  libboost-thread-dev \
  build-essential \
  python-pyrex \
  libnspr4-dev \
  libemu-dev \
  python-pip \
  python-dev \
  subversion \
  unzip \
  swig \
  wget \
  git' \
  && set -x \
  && apt-get update -qq \
  && apt-get install -y $buildDeps python python-setuptools pkg-config python-libemu python-lxml python-pil --no-install-recommends \
  && echo "===> Install malice/pdf plugin..." \
  && cd /usr/sbin \
  && export PIP_NO_CACHE_DIR=off \
  && export PIP_DISABLE_PIP_VERSION_CHECK=on \
  # && pip install --upgrade pip wheel \
  && echo "\t[*] install requirements..." \
  && pip install --no-cache-dir -U -r requirements.txt \
  && echo "\t[*] install pyv8..." \
  && pip install --no-cache-dir git+https://github.com/flier/pyv8.git \
  && echo "\t[*] install peepdf..." \
  && git clone https://github.com/jbremer/peepdf.git peepdf \
  && echo "\t[*] install pdfscan.py..." \
  && chmod +x pdfscan.py \
  && ln -s /usr/sbin/pdfscan.py /usr/sbin/pdfscan \
  && echo "\t[*] clean up..." \
  && apt-get purge -y --auto-remove $buildDeps $(apt-mark showauto) \
  && apt-get clean \
  && rm requirements.txt Dockerfile VERSION \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/*

# RUN apk --update add --no-cache python py-setuptools
# RUN apk --update add --no-cache -t .build-deps \
#   openssl-dev \
#   build-base \
#   python-dev \
#   libffi-dev \
#   musl-dev \
#   libc-dev \
#   py-pip \
#   gcc \
#   git \
#   && set -ex \
#   && echo "===> Install malice/pdf plugin..." \
#   && cd /usr/sbin \
#   && export PIP_NO_CACHE_DIR=off \
#   && export PIP_DISABLE_PIP_VERSION_CHECK=on \
#   && pip install --upgrade pip wheel \
#   && echo "\t[*] install requirements..." \
#   && pip install -U -r requirements.txt \
#   && echo "\t[*] install peepdf..." \
#   && pip install svn+http://pyv8.googlecode.com/svn/trunk/ \
#   && pip install git+https://github.com/jbremer/peepdf.git \
#   && echo "\t[*] install pdfscan.py..." \
#   && chmod +x pdfscan.py \
#   && ln -s /usr/sbin/pdfscan.py /usr/sbin/pdfscan \
#   && echo "\t[*] clean up..." \
#   && rm requirements.txt Dockerfile VERSION \
#   && apk del --purge .build-deps

WORKDIR /malware

ENTRYPOINT ["pdfscan"]
CMD ["--help"]
