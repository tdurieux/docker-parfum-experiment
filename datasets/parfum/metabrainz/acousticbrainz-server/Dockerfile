FROM metabrainz/python:3.7 AS acousticbrainz-base

# Dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Install dependencies
# Hadolint DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Node
RUN wget -q -O - https://deb.nodesource.com/setup_12.x | bash - && apt-get update \
    && apt-get install -y --no-install-recommends \
                       build-essential \
                       ca-certificates \
                       git \
                       ipython \
                       libavcodec-dev \
                       libavformat-dev \
                       libavutil-dev \
                       libavresample-dev \
                       libffi-dev \
                       libfftw3-dev \
                       libpq-dev \
                       libsamplerate0-dev \
                       libqt4-dev \
                       libssl-dev \
                       libtag1-dev \
                       libxml2-dev \
                       libxslt1-dev \
                       libyaml-dev \
                       nodejs \
                       pkg-config \
                       pxz \
                       python-dev \
                       python-numpy-dev \
                       python-numpy \
                       swig2.0 \
                       zstd \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /code
RUN mkdir /data
WORKDIR /code

RUN groupadd --gid 901 acousticbrainz
RUN useradd --create-home --shell /bin/bash --uid 901 --gid 901 acousticbrainz

RUN chown acousticbrainz:acousticbrainz /code

RUN pip install pip==21.1.2

# By default annoy compiles its C++ code using gcc's -march=native flag. This means that if it compiles
# on a recent Intel machine (e.g. in github actions) it might use extensions that aren't available
# on our production machines (AVX512). Force it to a lower arch that is compatible over all of our
# productions servers (skylake, zen1, zen2)
ENV ANNOY_COMPILER_ARGS=-D_CRT_SECURE_NO_WARNINGS,-DANNOYLIB_MULTITHREADED_BUILD,-march=haswell,-mno-rdrnd,-O3,-ffast-math,-fno-associative-math,-std=c++14

# Python dependencies
RUN mkdir /code/docs/ && chown acousticbrainz:acousticbrainz /code/docs/
COPY --chown=acousticbrainz:acousticbrainz docs/requirements.txt /code/docs/requirements.txt
COPY --chown=acousticbrainz:acousticbrainz requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt


FROM acousticbrainz-base AS acousticbrainz-dev

COPY --chown=acousticbrainz:acousticbrainz requirements_development.txt /code/requirements_development.txt
RUN pip install --no-cache-dir -r requirements_development.txt


# We don't copy code to the dev image because it's added with a volume mount
# during development, however it's needed for tests. Add it here.
FROM acousticbrainz-dev AS acousticbrainz-test

COPY . /code


FROM acousticbrainz-base AS acousticbrainz-prod
USER root

RUN pip install --no-cache-dir uWSGI==2.0.17.1

RUN mkdir /cache_namespaces && chown -R acousticbrainz:acousticbrainz /cache_namespaces

# runit service files
# All services are created with a `down` file, preventing them from starting
# rc.local removes the down file for the specific service we want to run in a container
# http://smarden.org/runit/runsv.8.html

# uwsgi service files
COPY ./docker/uwsgi/uwsgi.service /etc/service/uwsgi/run
COPY ./docker/uwsgi/uwsgi.ini /etc/uwsgi/uwsgi.ini
COPY ./docker/uwsgi/consul-template-uwsgi.conf /etc/consul-template-uwsgi.conf
RUN touch /etc/service/uwsgi/down

# Standalone version of uwsgi that doesn't require consul
COPY ./docker/uwsgistandalone/uwsgi.service /etc/service/uwsgistandalone/run
COPY ./docker/uwsgistandalone/uwsgi.ini /etc/uwsgi/uwsgi-standalone.ini
RUN touch /etc/service/uwsgistandalone/down

# hl_extractor service files
COPY ./docker/hl_extractor/hl_extractor.service /etc/service/hl_extractor/run
COPY docker/hl_extractor/consul-template-hl-extractor.conf /etc/consul-template-hl-extractor.conf
RUN touch /etc/service/hl_extractor/down

# dataset evaluator service files
COPY ./docker/dataset_eval/dataset_eval.service /etc/service/dataset_eval/run
COPY ./docker/dataset_eval/consul-template-dataset-eval.conf /etc/consul-template-dataset-eval.conf
RUN touch /etc/service/dataset_eval/down

# Add cron jobs
COPY ./docker/cron/crontab /etc/cron.d/acousticbrainz
RUN chmod 0644 /etc/cron.d/acousticbrainz
COPY ./docker/cron/cron-config.service /etc/service/cron-config/run
COPY docker/cron/consul-template-cron-config.conf /etc/consul-template-cron-config.conf
RUN touch /etc/service/cron/down
RUN touch /etc/service/cron-config/down

COPY ./docker/rc.local /etc/rc.local
COPY ./docker/run-ab-command /usr/bin/run-ab-command

COPY --chown=acousticbrainz:acousticbrainz package.json /code

USER acousticbrainz
RUN npm install

COPY --chown=acousticbrainz:acousticbrainz . /code

RUN npm run build:prod

# Our entrypoint runs as root
USER root

ARG GIT_COMMIT_SHA
ENV GIT_SHA ${GIT_COMMIT_SHA}
