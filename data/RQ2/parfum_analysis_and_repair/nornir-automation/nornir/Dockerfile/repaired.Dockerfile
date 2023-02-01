ARG PYTHON
FROM python:${PYTHON}-slim-stretch

ENV PATH="/root/.poetry/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    NORNIR_TESTS=1

RUN apt-get update \
    && apt-get install --no-install-recommends -yq curl git pandoc make \
    && curl -f -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python \
    && poetry config virtualenvs.create false && rm -rf /var/lib/apt/lists/*;

COPY pyproject.toml .
COPY poetry.lock .

# Dependencies change more often, so we break RUN to cache the previous layer
RUN poetry install --no-interaction

ARG NAME
WORKDIR /${NAME}

COPY . .

# Install the project as a package
RUN poetry install --no-interaction

CMD ["/bin/bash"]

