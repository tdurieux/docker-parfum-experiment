FROM python:3.7-alpine

WORKDIR /app

RUN apk --update --no-cache add openssl ca-certificates py-openssl wget
RUN apk --update --no-cache add --virtual build-dependencies libffi-dev openssl-dev build-base libxslt-dev
RUN apk --update --no-cache add postgresql-dev

RUN pip install --no-cache-dir pipenv
COPY Pipfile* /app/
RUN pipenv install --system

ADD ./app/backend ./app/backend/

WORKDIR /app/app/backend/

CMD gunicorn -k uvicorn.workers.UvicornWorker -c gunicorn.conf.py server.main:app --access-logfile '-'
