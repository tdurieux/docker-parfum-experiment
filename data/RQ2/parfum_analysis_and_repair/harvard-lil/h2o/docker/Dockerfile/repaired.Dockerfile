FROM registry.lil.tools/library/python:3.9-bullseye
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_SRC=/usr/local/src

RUN apt-get update && apt-get install --no-install-recommends -y nano postgresql-client && rm -rf /var/lib/apt/lists/*;

# pin node version -- see https://github.com/nodesource/distributions/issues/33
RUN curl -f -o nodejs.deb https://deb.nodesource.com/node_16.x/pool/main/n/nodejs/nodejs_16.14.0-deb-1nodesource1_$(dpkg --print-architecture).deb \
    && dpkg -i ./nodejs.deb \
    && rm nodejs.deb

RUN mkdir -p /app/web
WORKDIR /app/web

# pip
COPY web/requirements.txt /app/web
RUN pip install --no-cache-dir pip==21.3.1 \
    && pip install --no-cache-dir -r requirements.txt \
    && rm requirements.txt
