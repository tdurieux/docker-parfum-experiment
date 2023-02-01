FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /src
COPY register-postgres.json .

SHELL [ "bash" ]
CMD [ "curl", "-i", "-X", "POST", "-H", "Accept:application/json", "-H", "Content-Type:application/json", "http://connect:8083/connectors/", "-d", "@register-postgres.json" ]
