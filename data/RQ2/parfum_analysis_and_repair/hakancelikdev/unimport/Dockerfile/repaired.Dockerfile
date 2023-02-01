FROM python:3.9-alpine

COPY . /app
WORKDIR /app

RUN apk add --no-cache cargo

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir .

ENTRYPOINT [ "python", "-m", "unimport" ]
