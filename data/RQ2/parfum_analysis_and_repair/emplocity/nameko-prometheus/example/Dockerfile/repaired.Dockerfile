FROM python:3.8.4-slim

RUN apt-get update && apt-get install --no-install-recommends -y build-essential wait-for-it && \
    pip install --no-cache-dir nameko 'dnspython<2' https://github.com/Emplocity/nameko-prometheus/archive/master.zip#egg=nameko_prometheus && rm -rf /var/lib/apt/lists/*;

COPY . /var/run/my_service

WORKDIR /var/run/my_service

CMD ["wait-for-it", "--host=rabbitmq", "--port=5672", "--timeout=10", "--strict", "--", \
    "nameko", "run", "service:MyService", "--config", "config.yml"]
