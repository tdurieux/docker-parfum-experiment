FROM python:3.7.3

WORKDIR /app
ADD . /app

RUN set -ex; \
    pip install --no-cache-dir -r requirements.txt;

ENTRYPOINT [ "python3" ]
