FROM python:3.6.3-alpine3.4

WORKDIR /app

RUN set -ex \
  && apk add --no-cache --virtual .build-deps \
    gcc \
    musl-dev \
    python3-dev \
  && python3 -m pip install --no-cache-dir mypy \
  && apk del .build-deps

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir pytest

COPY . /app

RUN mkdir /data
CMD ["sh", "-c", "python main.py dbinit && mypy ytdl/ && pytest"]