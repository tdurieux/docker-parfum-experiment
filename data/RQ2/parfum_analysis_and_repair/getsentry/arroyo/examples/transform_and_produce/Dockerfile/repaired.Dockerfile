FROM python:3.8.13

RUN apt-get update && apt-get install --no-install-recommends -y librdkafka-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir sentry-arroyo

COPY . /app
