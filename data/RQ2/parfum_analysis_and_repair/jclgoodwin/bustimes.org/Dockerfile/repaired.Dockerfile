FROM python:3.10-bullseye

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y gdal-bin npm && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir poetry

WORKDIR /app/
COPY poetry.lock pyproject.toml /app/
RUN poetry install

COPY package.json package-lock.json /app/
RUN npm install && npm cache clean --force;
