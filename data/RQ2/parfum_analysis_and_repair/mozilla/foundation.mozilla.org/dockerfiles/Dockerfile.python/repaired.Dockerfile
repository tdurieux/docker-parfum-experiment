FROM python:3.9.9-slim

RUN apt-get update && apt-get install -y \
      gettext \
      git \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# We want output
ENV PYTHONUNBUFFERED 1
# We don't want *.pyc
ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /app/