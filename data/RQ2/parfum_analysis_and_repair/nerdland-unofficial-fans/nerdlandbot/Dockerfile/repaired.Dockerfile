FROM python:3.8.6-slim-buster as base

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1

FROM base as builder

ENV VIRTUAL_ENV=/venv \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.1.4

RUN pip install --no-cache-dir "poetry==$POETRY_VERSION"
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY pyproject.toml poetry.lock ./
RUN poetry export -f requirements.txt | pip install --no-cache-dir -r /dev/stdin

COPY . .
RUN poetry build && pip install --no-cache-dir dist/*.whl

FROM base as final

ENV VIRTUAL_ENV=/venv

COPY --from=builder $VIRTUAL_ENV $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"
CMD ["python", "-m", "nerdlandbot"]
