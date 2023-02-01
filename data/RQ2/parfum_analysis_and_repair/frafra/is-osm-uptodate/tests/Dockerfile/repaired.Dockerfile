FROM python:3.10-bullseye AS apt
LABEL maintainer="fraph24@gmail.com"
ARG DEBIAN_FRONTEND=noninteractive
RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
    apt-get update && apt-get -qy --no-install-recommends install firefox-esr xvfb && rm -rf /var/lib/apt/lists/*; WORKDIR /app



COPY pyproject.toml pdm.lock ./
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/pdm \
    pip3 install --no-cache-dir pdm && \
    pdm install --no-default -G test && \
    pdm run seleniumbase install geckodriver
COPY tests/test_api.py tests/test_webapp.py tests/common.py tests/
ENV DISPLAY=:99

CMD ["pdm", "run", "test"]
