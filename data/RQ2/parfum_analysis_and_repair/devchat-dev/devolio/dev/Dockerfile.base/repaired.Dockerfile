FROM python:3.6-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python3-dev libffi-dev && rm -rf /var/lib/apt/lists/*;
ENV PYTHONUNBUFFERED 1
