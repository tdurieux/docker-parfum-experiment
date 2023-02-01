FROM python:3.6-alpine
RUN rm -rf /var/cache/apk/* && \
    apk update && \
    apk add --no-cache make && \
    apk add --no-cache build-base && \
    apk add --no-cache gcc && \
    apk add --no-cache python3-dev && \
    apk add --no-cache libffi-dev && \
    apk add --no-cache musl-dev && \
    apk add --no-cache openssl-dev && \
    apk del build-base && \
    rm -rf /var/cache/apk/*

ENV HOME=/home/api FLASK_APP=application.py FLASK_ENV=production WORKERS=4 PORT=5000
RUN adduser -D api
USER api
WORKDIR $HOME
COPY --chown=api:api . $HOME

RUN python -m venv venv && \
    venv/bin/pip install --upgrade pip && \
    venv/bin/pip install -r requirements/prod.txt

EXPOSE 5000
ENTRYPOINT [ "./boot.sh" ]
