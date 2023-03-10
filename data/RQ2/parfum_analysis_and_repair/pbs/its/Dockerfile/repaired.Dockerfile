FROM python:3.6.6-alpine3.7

ENV PYTHONUNBUFFERED 1

WORKDIR /opt/its

# install necessary libraries
RUN apk add --no-cache \
    bash \
    ca-certificates \
    cyrus-sasl-dev \
    g++ \
    gcc \
    jpeg-dev \
    lcms2-dev \
    libffi-dev \
    libmemcached-dev \
    libwebp-dev \
    libxslt-dev \
    linux-headers \
    make \
    memcached \
    openssl \
    openssl-dev \
    pngquant \
    py-lxml \
    python3-dev \
    zlib-dev \
  && rm /bin/sh \
  && ln -s /bin/bash /bin/sh

# create its user and group
RUN mkdir -p /opt/its \
  && mkdir -p /etc/its \
  && mkdir -p /home/its \
  && addgroup its \
  && adduser -D -u 1000 -G its its \
  && chown --recursive its:its /etc/its \
  && chown --recursive its:its /home/its \
  && chown --recursive its:its /opt/its

USER its

ENV PATH /home/its/.local/bin:$PATH

# install runtime requirements
# pinned pipenv version to temporarily support python3.6
RUN pip install --no-cache-dir --user pipenv==2022.4.8 \
  && pipenv --three

COPY Pipfile Pipfile.lock /opt/its/

RUN pipenv install --dev

# copy source code
COPY --chown=its:its its/ /opt/its/its/
COPY --chown=its:its etc/ /etc/its/
COPY --chown=its:its its.ini /opt/its/its.ini
COPY --chown=its:its scripts/docker/ /opt/its/scripts/docker
COPY --chown=its:its .prospector.yml /opt/its/
COPY --chown=its:its .mypy.ini /opt/its/
