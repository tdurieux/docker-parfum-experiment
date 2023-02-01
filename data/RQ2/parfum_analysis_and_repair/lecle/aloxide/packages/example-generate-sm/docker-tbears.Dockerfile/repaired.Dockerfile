###
# https://www.icondev.io/docs/tbears-installation#setup-on-linux
# install `tbears` command
###
FROM python:3.7.3-slim-stretch

RUN apt-get update && apt-get install -y --no-install-recommends \
 gcc \
 libc-dev \
 pkg-config && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir virtualenv

RUN virtualenv -p python3 venv\
  && chmod +x ./venv/bin/activate\
  && ./venv/bin/activate \
  && pip3 install --no-cache-dir tbears

WORKDIR /app

VOLUME ["/app"]

ENTRYPOINT [ "tbears" ]
