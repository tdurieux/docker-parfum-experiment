FROM python:3.9.7-alpine
ARG VERSION

WORKDIR .
COPY dist/pyatv-${VERSION}-py3-none-any.whl .

RUN apk add --no-cache gcc musl-dev build-base linux-headers libffi-dev rust cargo openssl-dev git && \
    pip install --no-cache-dir setuptools-rust && \
    pip install --no-cache-dir pyatv-${VERSION}-py3-none-any.whl && \
    apk del gcc musl-dev build-base linux-headers libffi-dev rust cargo openssl-dev git && \
    rm pyatv-${VERSION}-py3-none-any.whl && \
    rm -rf /root/.cache /root/.cargo
