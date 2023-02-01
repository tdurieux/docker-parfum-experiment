FROM ubuntu:20.04

WORKDIR /usr/src/app

RUN apt-get update \
    && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

COPY requirements /requirements

ARG DEV

RUN pip install -r /requirements/prod.txt ${DEV:+-r /requirements/dev.txt} --no-cache-dir

COPY . .
