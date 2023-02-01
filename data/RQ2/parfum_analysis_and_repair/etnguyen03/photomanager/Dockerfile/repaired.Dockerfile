FROM python:3.8-buster

COPY . /app
WORKDIR /app

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install cmake && \
    pip install --no-cache-dir pipenv && \
    pipenv install --deploy --system && \
    chmod +x /app/scripts/docker-entrypoint.sh && \
    apt-get clean && rm -f /var/lib/apt/lists/*_*

EXPOSE 8000
VOLUME /data
VOLUME /app/photomanager/settings/secret.py
VOLUME /thumbs

ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]