# before changing these variables, make sure the tag $PYTHON-alpine$ALPINE exists first
# list of valid tags hese: https://hub.docker.com/_/pypy
ARG PYTHON=3.9
ARG DEBIAN=bullseye

# stage-0: copy pyproject.toml/poetry.lock and install the production set of dependencies
FROM pypy:$PYTHON-slim-$DEBIAN as stage-0
ARG PYTHON
# install runtime first deps to speedup the dev deps and because layers will be reused on stage-1
RUN apt-get -qy update && apt-get -qy upgrade
RUN apt-get -qy --no-install-recommends install libssl1.1 graphviz librocksdb6.11 && rm -rf /var/lib/apt/lists/*;
# dev deps for this build start here
RUN apt-get -qy --no-install-recommends install libssl-dev libffi-dev build-essential zlib1g-dev libbz2-dev libsnappy-dev liblz4-dev librocksdb-dev cargo git pkg-config && rm -rf /var/lib/apt/lists/*;
# install all deps in a virtualenv so we can just copy it over to the final image
RUN pip --no-input --no-cache-dir install --upgrade pip wheel poetry
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
WORKDIR /app/
COPY pyproject.toml poetry.lock  ./
RUN poetry install -n -E sentry --no-root --no-dev
COPY hathor ./hathor
COPY README.md ./
RUN poetry build -f wheel
RUN poetry run pip install dist/hathor-*.whl

# finally: use production .venv from before
# lean and mean: this image should be about ~50MB, would be about ~470MB if using the whole stage-1
FROM pypy:$PYTHON-slim-$DEBIAN
ARG PYTHON
RUN apt-get -qy update && apt-get -qy upgrade
RUN apt-get -qy --no-install-recommends install libssl1.1 graphviz librocksdb6.11 && rm -rf /var/lib/apt/lists/*;
COPY --from=stage-0 /app/.venv/lib/pypy${PYTHON}/site-packages/ /opt/pypy/lib/pypy${PYTHON}/site-packages/
EXPOSE 40403 8080
ENTRYPOINT ["pypy", "-m", "hathor"]
