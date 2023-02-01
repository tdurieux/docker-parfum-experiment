FROM python:3-slim AS builder
ADD main.py /app/main.py
WORKDIR /app

RUN pip install --no-cache-dir --target=/app requests
RUN pip install --no-cache-dir --target=/app -U pip setuptools wheel
RUN pip install --no-cache-dir --target=/app ruamel.yaml

FROM gcr.io/distroless/python3-debian10
COPY --from=builder /app /app
WORKDIR /app
ENV PYTHONPATH /app
CMD ["/app/main.py"]