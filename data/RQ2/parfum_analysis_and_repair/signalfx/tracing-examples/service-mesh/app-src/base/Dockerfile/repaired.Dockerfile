FROM ubuntu:18.04

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python-pip python-dev curl && rm -rf /var/lib/apt/lists/*;

COPY . /app/
WORKDIR /app/
RUN pip install --no-cache-dir -r ./requirements.txt

WORKDIR /app/signalfx-python-tracing
RUN ./scripts/bootstrap.py --jaeger

WORKDIR /app
