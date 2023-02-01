#Copyright (c) 2021, Intel Corporation.
#SPDX-License-Identifier: BSD-3-Clause

FROM python:3.8-slim-buster

COPY . /workspace
WORKDIR /workspace/src/device_manager

RUN apt update ; apt install --no-install-recommends -y v4l-utils kmod sudo && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U poetry && \
    poetry install

ENTRYPOINT [ "poetry", "run", "python3", "api.py" ]
