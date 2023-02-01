FROM python:3.9-slim

RUN apt-get update && apt-get install --no-install-recommends -y \
  wget \
  pandoc \
  rsync \
  && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --default-timeout=100 -r /tmp/requirements.txt

WORKDIR /opt/src/etl

ENTRYPOINT ["./scripts/build_all"]
