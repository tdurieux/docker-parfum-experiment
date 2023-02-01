# build env
FROM node:16-alpine as build

COPY ./frontend /frontend
WORKDIR /frontend
RUN npm install && npm run build && rm -rf node_modules && npm cache clean --force;

# prod env
FROM python:3.9-slim-buster

RUN apt-get update \
	&& apt-get install --no-install-recommends -y libmagic-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /backend

COPY pyproject.toml poetry.lock /backend/
COPY gunicorn.conf.py /backend
COPY app /backend/app

RUN pip3 install --no-cache-dir poetry && poetry config virtualenvs.create false && poetry install --no-dev

COPY --from=build /frontend /backend/frontend

ENV PORT 8000

EXPOSE $PORT

CMD gunicorn -k uvicorn.workers.UvicornWorker app:app
