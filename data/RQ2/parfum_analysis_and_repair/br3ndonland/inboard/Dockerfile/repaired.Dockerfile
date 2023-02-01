# syntax=docker/dockerfile:1
ARG PYTHON_VERSION=3.10 LINUX_VERSION=
FROM python:${PYTHON_VERSION}${LINUX_VERSION:+-$LINUX_VERSION} AS builder
LABEL org.opencontainers.image.authors="Brendon Smith <bws@bws.bio>"
LABEL org.opencontainers.image.description="Docker images and utilities to power your Python APIs and help you ship faster."
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/br3ndonland/inboard"
LABEL org.opencontainers.image.title="inboard"
LABEL org.opencontainers.image.url="https://github.com/br3ndonland/inboard/pkgs/container/inboard"
ARG LINUX_VERSION PIPX_VERSION=1.1.0 POETRY_VERSION=1.1.11
ENV APP_MODULE=inboard.app.main_base:app LINUX_VERSION=$LINUX_VERSION PATH=/opt/pipx/bin:/app/.venv/bin:$PATH PIPX_BIN_DIR=/opt/pipx/bin PIPX_HOME=/opt/pipx/home PIPX_VERSION=$PIPX_VERSION POETRY_VERSION=$POETRY_VERSION PYTHONPATH=/app
COPY --link poetry.lock poetry.toml pyproject.toml /app/
WORKDIR /app
RUN <<HEREDOC
. /etc/os-release
if [ "$ID" = "alpine" ]; then
  apk add --no-cache --virtual .build-deps \
    gcc libc-dev libffi-dev make openssl-dev
elif [ "$LINUX_VERSION" = "slim" ]; then
  apt-get update -qy
  apt-get install -qy --no-install-recommends \
    gcc libc-dev make wget
fi
python -m pip install --no-cache-dir --upgrade pip "pipx==$PIPX_VERSION"
pipx install "poetry==$POETRY_VERSION"
poetry install --no-dev --no-interaction --no-root
HEREDOC
COPY --link inboard /app/inboard
ENTRYPOINT ["python"]
CMD ["-m", "inboard.start"]

FROM builder as base
RUN <<HEREDOC
. /etc/os-release
if [ "$ID" = "alpine" ]; then
  apk del .build-deps
elif [ "$LINUX_VERSION" = "slim" ]; then
  apt-get purge --auto-remove -qy \
    gcc libc-dev make wget
fi
HEREDOC

FROM builder AS fastapi
ENV APP_MODULE=inboard.app.main_fastapi:app
RUN <<HEREDOC
poetry install --no-dev --no-interaction --no-root -E fastapi
. /etc/os-release
if [ "$ID" = "alpine" ]; then
  apk del .build-deps
elif [ "$LINUX_VERSION" = "slim" ]; then
  apt-get purge --auto-remove -qy \
    gcc libc-dev make wget
fi
HEREDOC

FROM builder AS starlette
ENV APP_MODULE=inboard.app.main_starlette:app
RUN <<HEREDOC
poetry install --no-dev --no-interaction --no-root -E starlette
. /etc/os-release
if [ "$ID" = "alpine" ]; then
  apk del .build-deps
elif [ "$LINUX_VERSION" = "slim" ]; then
  apt-get purge --auto-remove -qy \
    gcc libc-dev make wget
fi
HEREDOC