# Copyright (C) 2021 Intel Corporation
# Licensed under the MIT license. See LICENSE file in the project root for
# full license information.

FROM arm32v7/python:3.7-buster as builder

WORKDIR /app

# Required for ffmpeg to skip building unnecessary RUST
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY ./package ./package
COPY ./main.py .

CMD [ "python3", "-u", "./main.py" ]