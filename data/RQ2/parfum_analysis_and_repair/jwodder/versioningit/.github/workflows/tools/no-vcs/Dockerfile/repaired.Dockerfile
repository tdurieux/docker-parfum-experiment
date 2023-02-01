FROM python:3.6-slim
RUN set -ex; \
    pip install --no-cache-dir --upgrade pip wheel; \
    pip install --no-cache-dir --upgrade --upgrade-strategy=eager tox
