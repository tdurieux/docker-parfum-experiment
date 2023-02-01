FROM python:alpine

WORKDIR /opt/app

ENV APP_ENV="container"

COPY . .

RUN apk add -u --no-cache tzdata gcc musl-dev libxml2 libxslt-dev && \
    pip install --no-cache-dir wheel && \
    pip install --no-cache-dir -r requirements.txt

ENV PORT=8000

ENTRYPOINT ["/bin/sh","launch.sh"]