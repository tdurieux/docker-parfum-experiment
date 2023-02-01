FROM python:3.9-slim AS builder
RUN apt-get update && apt-get install -y --no-install-recommends build-essential gcc && rm -rf /var/lib/apt/lists/*;

RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

RUN mkdir /iter8-analytics
WORKDIR /iter8-analytics

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY setup.py .
COPY iter8_analytics/ ./iter8_analytics/
RUN pip install --no-cache-dir -e .

FROM python:3.9-slim AS build-image
COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /iter8-analytics /iter8-analytics

WORKDIR /iter8-analytics/iter8_analytics

# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"
CMD ["python", "fastapi_app.py"]
