# Less size than Debian, slowest to build
FROM python:3.10-alpine

ENV PYTHONUNBUFFERED 1
WORKDIR /app

COPY requirements.txt ./

# Signal handling for PID1 https://github.com/krallin/tini