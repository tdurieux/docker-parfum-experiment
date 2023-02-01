FROM malice/alpine:tini

MAINTAINER {{ creator }}

COPY . /tmp/src/{{ plugin_name }}
RUN apk-install python
RUN apk-install -t .build-deps git mercurial py-pip \
  && set -x \
  && cd /tmp/src/{{ plugin_name }} \
  && export PIP_NO_CACHE_DIR=off \
  && export PIP_DISABLE_PIP_VERSION_CHECK=on \
  && pip install --no-cache-dir --upgrade pip wheel \
  && pip install --no-cache-dir -r requirements.txt \
  && python setup.py install \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

WORKDIR /malware

ENTRYPOINT ["/bin/scan"]

CMD ["--help"]