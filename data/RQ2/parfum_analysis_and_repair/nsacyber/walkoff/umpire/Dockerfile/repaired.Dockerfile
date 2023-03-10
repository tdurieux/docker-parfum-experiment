FROM python:3.7.4-slim-buster as base

# Stage - Install/build Python dependencies
FROM base as builder

RUN apt-get update \
 && apt-get install -y --no-install-recommends git autoconf g++ libffi-dev libssl-dev\
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /install
WORKDIR /install

COPY ./umpire/requirements.txt /requirements.txt
RUN pip install --no-cache-dir --no-warn-script-location --prefix="/install" git+https://github.com/aio-libs/aioredis.git
RUN pip install --no-cache-dir --no-warn-script-location --prefix="/install" --no-deps asteval
RUN pip install --no-cache-dir --no-warn-script-location --prefix="/install" -r /requirements.txt

# Stage - Copy pip packages and source files
FROM base

COPY --from=builder /install /usr/local
COPY ./app_sdk /app/app_sdk
COPY ./worker /app/worker
COPY ./common /app/common
COPY ./umpire /app/umpire
#COPY ./umpire/umpire_api.py /app

WORKDIR /app

CMD python -m umpire.umpire