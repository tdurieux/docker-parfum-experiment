FROM python:3.9-slim-buster

WORKDIR /app

COPY . .

RUN apt-get update \
    && apt-get install -y --no-install-recommends bash \
    && pip install --no-cache-dir -r requirements.txt \
    && chmod +x /app/entrypoint.sh && rm -rf /var/lib/apt/lists/*;

EXPOSE 5000

ENTRYPOINT ["/app/entrypoint.sh"]