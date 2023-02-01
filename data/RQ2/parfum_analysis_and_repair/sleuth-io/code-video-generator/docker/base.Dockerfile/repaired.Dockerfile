FROM python:3.9-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt update \
    && apt -y --no-install-recommends install git wget unzip build-essential libcairo2-dev ffmpeg libsndfile1 libpango1.0-dev && rm -rf /var/lib/apt/lists/*;
