# Digital Ocean App Platform

FROM nikolaik/python-nodejs:python3.10-nodejs17-bullseye

RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y gdal-bin && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir poetry

WORKDIR /app/
COPY poetry.lock pyproject.toml /app/
RUN poetry install

COPY package.json package-lock.json /app/
RUN npm install && npm cache clean --force;

COPY . /app/

ENV SECRET_KEY=f
ENV STATIC_ROOT=/app/staticfiles
RUN make build-static
RUN poetry run ./manage.py collectstatic --noinput
