# https://hub.docker.com/_/python/
FROM python:3.10-alpine

WORKDIR /opt/index-digest

# copy files required to run "pip install"
ADD setup.py README.md ./
ADD ./indexdigest/__init__.py ./indexdigest/__init__.py

# installs mysql_config and pip dependencies
# https://github.com/gliderlabs/docker-alpine/issues/181
RUN apk upgrade \
    && apk add --no-cache --virtual build-deps gcc musl-dev \
    && apk add --no-cache mariadb-dev \
    && pip install --no-cache-dir . \
    && rm -rf /root/.cache \
    && apk del build-deps

ARG GITHUB_SHA="dev"
ENV COMMIT_SHA ${GITHUB_SHA}

# install the remaining files
ADD . .

# run as nobody
ENV HOME /opt/index-digest
RUN chown -R nobody .
USER nobody

# install the entire package
RUN pip install --no-cache-dir --no-warn-script-location --user . \
    && rm -rf ~./cache

RUN index_digest --version

# docker run -t macbre/index-digest
ENTRYPOINT ["index_digest"]
