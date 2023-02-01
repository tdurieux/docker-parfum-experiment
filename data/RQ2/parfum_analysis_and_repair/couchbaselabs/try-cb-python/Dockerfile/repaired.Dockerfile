FROM python:3.9-slim-buster

LABEL maintainer="Couchbase"

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential cmake \
    git-all libssl-dev \
    jq curl && rm -rf /var/lib/apt/lists/*;

ADD . /app

RUN pip install --no-cache-dir -r requirements.txt

# Expose ports
EXPOSE 8080

# Set the entrypoint
ENTRYPOINT ["./wait-for-couchbase.sh", "python", "travel.py"]
