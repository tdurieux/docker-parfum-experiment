FROM tiangolo/node-frontend:10 as build-stage
WORKDIR /app
COPY package*.json /app/
RUN npm install && npm cache clean --force;
COPY webpack.*.js .babelrc /app/
COPY ./app/frontend ./app/frontend
RUN npm run build



FROM python:3.7-alpine

WORKDIR /app

RUN apk --update --no-cache add openssl ca-certificates py-openssl wget
RUN apk --update --no-cache add --virtual build-dependencies libffi-dev openssl-dev build-base libxslt-dev
RUN apk --update --no-cache add postgresql-dev

RUN pip install --no-cache-dir pipenv
COPY Pipfile* /app/
RUN pipenv install --system

ADD ./app/backend ./app/backend/
COPY --from=build-stage /app/app/frontend/dist/static/ /app/app/backend/server/static/
COPY --from=build-stage /app/app/frontend/dist/index.html /app/app/backend/server/templates/


WORKDIR /app/app/backend/

CMD gunicorn -k uvicorn.workers.UvicornWorker -c gunicorn.conf.py server.main:app --access-logfile '-'
