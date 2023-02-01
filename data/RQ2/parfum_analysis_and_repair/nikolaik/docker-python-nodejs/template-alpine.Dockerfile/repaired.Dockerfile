# Generated %%NOW%%
# python: %%PYTHON_CANONICAL%%
# nodejs: %%NODEJS_CANONICAL%%
FROM python:%%PYTHON_IMAGE%% as builder

RUN apk add --no-cache curl gcc musl-dev libffi-dev
# FIXME: poetry: Replace workaround for missing cffi musllinux wheel builds when https://foss.heptapod.net/pypy/cffi/-/issues/509 is ready
RUN pip install --no-cache-dir cffi
RUN find /root/.cache/pip/wheels -name '*.whl' -exec cp {} / +
# Install node prereqs, nodejs and yarn
# Ref: https://raw.githubusercontent.com/nodejs/docker-node/master/Dockerfile-alpine.template
# Ref: https://yarnpkg.com/en/docs/install
RUN curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v%%NODEJS_CANONICAL%%/node-v%%NODEJS_CANONICAL%%-linux-x64-musl.tar.xz"
RUN curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v%%NODEJS_CANONICAL%%/SHASUMS256.txt"
RUN grep " node-v%%NODEJS_CANONICAL%%-linux-x64-musl.tar.xz\$" SHASUMS256.txt | sha256sum -c -
RUN tar -xf "node-v%%NODEJS_CANONICAL%%-linux-x64-musl.tar.xz" && rm "node-v%%NODEJS_CANONICAL%%-linux-x64-musl.tar.xz"

FROM python:%%PYTHON_IMAGE%%
MAINTAINER Nikolai R Kristiansen <nikolaik@gmail.com>

RUN addgroup -g 1000 pn && adduser -u 1000 -G pn -s /bin/sh -D pn
RUN apk add --no-cache libstdc++
COPY --from=builder /node-v%%NODEJS_CANONICAL%%-linux-x64-musl /usr/local
RUN npm i -g npm@^%%NPM_VERSION%% yarn && npm cache clean --force;
RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir pipenv
# Poetry
# Mimic what install-poetry.py does without the flexibility (platforms, install sources, etc).
# Also install wheels from builder image
COPY --from=builder /*.whl /
ENV VENV=/opt/poetryvenv
RUN python -m venv $VENV && $VENV/bin/pip install --no-cache-dir -U pip && $VENV/bin/pip install --no-cache-dir /*.whl && rm /*.whl
RUN $VENV/bin/pip install --no-cache-dir poetry && ln -s $VENV/bin/poetry /usr/local/bin/poetry
