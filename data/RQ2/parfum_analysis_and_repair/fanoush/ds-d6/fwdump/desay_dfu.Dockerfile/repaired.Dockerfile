FROM python:2.7.18-slim-buster AS base

RUN apt update && \
    apt install --no-install-recommends -y bluez && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir pexpect

WORKDIR /app
COPY desay_dfu.py ./

ENTRYPOINT [ "python", "./desay_dfu.py"]