# base stage for all environment variables
FROM python:3.7.9 as python-base
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1\
    PIP_NO_CACHE_DIR=off\
    PIP_DISABLE_PIP_VERSION_CHECK=on\
    PIP_DEFAULT_TIMEOUT=100\
    POETRY_VERSION=1.0.10\
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# stage for building python dependencies
FROM python-base as builder-base
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    build-essential && rm -rf /var/lib/apt/lists/*;
# install poetry - respects $POETRY_VERSION & $POETRY_HOME
RUN curl -f -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
# copy project requirement files here to ensure they will be cached.
WORKDIR $PYSETUP_PATH
COPY poetry.lock pyproject.toml ./
# install runtime deps - uses $POETRY_VIRTUALENVS_IN_PROJECT internally
RUN poetry install --no-dev

# stage for running everything
FROM python-base as production
COPY --from=builder-base $PYSETUP_PATH $PYSETUP_PATH
RUN mkdir /app
WORKDIR /app
COPY . /app/
