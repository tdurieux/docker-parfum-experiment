FROM python:3.9.5-slim AS builder

COPY ./ /app

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt && \
    apt-get update && apt-get install --no-install-recommends -y build-essential && \
    make html && rm -rf /var/lib/apt/lists/*;


FROM nginx:alpine

COPY --from=builder /app/build/html /usr/share/nginx/html

