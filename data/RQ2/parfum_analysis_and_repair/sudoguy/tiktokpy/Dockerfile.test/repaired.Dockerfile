FROM python:3.9-slim-buster as development_build

ARG ENV="production"

ENV ENV=${ENV} \
    DEBIAN_FRONTEND=noninteractive \
    # poetry:
    POETRY_VERSION='1.1.6' \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    # pip:
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100

# System deps
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    # build-essential \
    curl \
    git \
    # pyppeteer
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgcc1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    lsb-release \
    wget \
    xdg-utils \
    # Cleaning cache:
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
    # Installing `poetry` package manager:
    # https://github.com/python-poetry/poetry \
    && pip install --no-cache-dir "poetry==$POETRY_VERSION"

WORKDIR /app
# Copy only requirements, to cache them in docker layer
COPY ./pyproject.toml ./poetry.lock /app/

# Project initialization:
RUN echo "$ENV" \
    && poetry --version \
    && poetry install \
    $(if [ "$ENV" = 'production' ]; then echo '--no-dev'; fi) \
    --no-interaction --no-ansi \
    # Do not install the root package (the current project)
    --no-root \
    # Cleaning poetry installation's cache for production:
    && if [ "$ENV" = 'production' ]; then rm -rf "$POETRY_CACHE_DIR"; fi

RUN pyppeteer-install

# Setting up proper permissions:
RUN groupadd -r web && useradd -d /app -r -g web web \
    && chown web:web -R /app

COPY . /app/


CMD ["pytest"]
