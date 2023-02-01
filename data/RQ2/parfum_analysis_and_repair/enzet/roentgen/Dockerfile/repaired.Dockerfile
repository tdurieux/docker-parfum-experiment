FROM python:3.9-slim-bullseye

WORKDIR /app

COPY . /app/

RUN \
  apt update && \
  apt install -y --no-install-recommends gcc libcairo2-dev libgeos-dev && \
  pip install --no-cache-dir --upgrade pip && \
  pip install --no-cache-dir . && \
  mkdir -p /maps/cache && rm -rf /var/lib/apt/lists/*;

VOLUME ["/maps"]
ENTRYPOINT ["map-machine"]

