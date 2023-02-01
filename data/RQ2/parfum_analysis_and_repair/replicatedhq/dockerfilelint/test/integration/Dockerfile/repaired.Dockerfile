FROM ubuntu

RUN apt-get update && apt-get install -y --no-install-recommends python-pip && rm -rf /var/lib/apt/lists/*;

EXPOSE 8080:8080
