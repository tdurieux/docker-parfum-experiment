# `python-base` sets up all our shared environment variables
FROM python:3.9-slim as python-base

ENV PYTHONUNBUFFERED=1 \
    # prevents python creating .pyc files
    PYTHONDONTWRITEBYTECODE=1 \
    \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    \
    # https://python-poetry.org/docs/configuration/#using-environment-variables
    POETRY_VERSION=1.1.5 \
    # make poetry install to this location
    POETRY_HOME="/opt/poetry" \
    # make poetry create the virtual environment in the project's root
    # it gets named `.venv`
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    # do not ask any interactive question
    POETRY_NO_INTERACTION=1 \
    \
    # this is where our requirements + virtual environment will live
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"

# prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# `development` image is used during development / testing
FROM python-base as development

ENV DEBIAN_FRONTEND noninteractive
ENV GECKODRIVER_VER v0.30.0

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \
        build-essential \
        firefox-esr \
        unzip && rm -rf /var/lib/apt/lists/*;

# install poetry - respects $POETRY_VERSION & $POETRY_HOME
RUN curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

# copy project requirement files here to ensure they will be cached.
WORKDIR $PYSETUP_PATH
COPY poetry.lock pyproject.toml ./

ENV PATH="${PATH}:/root/.poetry/bin"

# install runtime deps - uses $POETRY_VIRTUALENVS_IN_PROJECT internally
RUN poetry install

# Add geckodriver
RUN set -x \
   && curl -f -sSLO https://github.com/mozilla/geckodriver/releases/download/${GECKODRIVER_VER}/geckodriver-${GECKODRIVER_VER}-linux64.tar.gz \
   && tar zxf geckodriver-*.tar.gz \
   && mv geckodriver /usr/bin/ && rm geckodriver-*.tar.gz

RUN curl -f -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python

ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# will become mountpoint of our code
WORKDIR /app

COPY ./run_e2e_tests.sh ./
COPY ./setup_localstack.py ./
COPY ./setup_ingestion.py ./
COPY ./parsing.py ./
COPY ./test_e2e.py ./

CMD [ "./run_e2e_tests.sh" ]
