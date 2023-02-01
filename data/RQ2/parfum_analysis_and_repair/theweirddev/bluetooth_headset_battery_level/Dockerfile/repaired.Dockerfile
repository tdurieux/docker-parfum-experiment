# Builder
FROM python:3.9-slim-bullseye as builder
RUN apt update && apt install --no-install-recommends -y build-essential bluetooth libbluetooth-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
RUN pip3 wheel --no-cache-dir --no-deps --wheel-dir /app/wheel/ pybluez

### Final
FROM python:3.9-slim-bullseye
RUN apt update && apt install --no-install-recommends -y libbluetooth3 && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY --from=builder /app/wheel /wheels
RUN pip3 install --no-cache-dir --no-cache /wheels/*
COPY ./bluetooth_battery.py .
ENTRYPOINT ["python3", "./bluetooth_battery.py"]
