FROM python:3.10-bullseye

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get clean && apt-get update && apt-get install -y gdal-bin npm && rm -rf /var/lib/apt/lists/*

RUN pip install poetry

WORKDIR /app/
COPY poetry.lock pyproject.toml /app/
RUN poetry install

COPY package.json package-lock.json /app/
RUN npm install
