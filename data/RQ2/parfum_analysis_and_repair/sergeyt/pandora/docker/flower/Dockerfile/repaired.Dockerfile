FROM python:3.8-alpine
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 PYTHONUNBUFFERED=1

COPY scripts /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt