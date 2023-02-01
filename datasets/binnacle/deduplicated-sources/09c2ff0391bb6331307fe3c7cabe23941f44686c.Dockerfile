FROM ubuntu:18.04

EXPOSE 80

# add the main app
ADD src /app

# add the docker entrypoint
ADD docker-entrypoint.sh /app

WORKDIR /app

# install app dependencies, build app and remove dev dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3 \
    python3-venv \
    python3-dev \
    python3-gdbm \
    gnupg \
    curl \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install nodejs -y \
    && npm --prefix frontend install \
    && mkdir -p staticassets \
    && npm --prefix frontend run build-prod \
    && python3 -m venv /env \
    && /env/bin/pip install --no-cache-dir -r requirements.txt \
    && /env/bin/python manage.py collectstatic --no-input \
    && rm -rf frontend/node_modules \
    && apt-get remove -y \
        build-essential \
        nodejs \
        python3-venv \
        python3-dev \
        curl \
        gnupg \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && true

ENTRYPOINT ["/app/docker-entrypoint.sh"]
