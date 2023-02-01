# Install all required packages and prepare vdk heartbeat
FROM python:3.7-slim AS builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential gcc && rm -rf /var/lib/apt/lists/*;

RUN python -m venv /opt/buildenv
ENV PATH="/opt/buildenv/bin:$PATH"

RUN pip install --no-cache-dir -U pip wheel
RUN pip install --no-cache-dir vdk-heartbeat


# Prepare the release heartbeat
FROM python:3.7-slim

COPY --from=builder /opt/buildenv /opt/buildenv
COPY vdk_heartbeat_config.ini heartbeat_config.ini
COPY start_heartbeat.sh .

RUN ["chmod", "+x", "start_heartbeat.sh"]

ENV PATH="/opt/buildenv/bin:$PATH"

CMD ["./start_heartbeat.sh", "heartbeat_config.ini"]
