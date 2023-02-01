ARG PYTHON_VERSION=3.8
FROM python:$PYTHON_VERSION

ENV NODE_VERSION 12

RUN echo "Installing system deps" \
    && apt-get update \
    && apt-get install --no-install-recommends -y build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN echo "Installing node and yarn" \
    && curl -f -sS "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash - \
    && curl -f -sS "https://dl.yarnpkg.com/debian/pubkey.gpg" | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y nodejs yarn \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# meltano core deps
COPY pyproject.toml .
COPY poetry.lock .
RUN pip install --no-cache-dir poetry && poetry install

ENTRYPOINT ["python"]
