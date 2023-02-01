FROM golang:1.15.7-buster

COPY . /backup_service

WORKDIR /backup_service

RUN apt-get update && \
    apt-get install --no-install-recommends -y lsb-release && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get -y --no-install-recommends install postgresql && \
    go mod vendor && \
    go build --mod=vendor -gcflags "all=-N -l" -o backup_service . && rm -rf /var/lib/apt/lists/*;

# RUN apt-get update && \
#     apt-get install postgresql-12 && \
#     go build --mod=vendor -gcflags "all=-N -l" -o backup_service .

ENTRYPOINT ["./backup_service"]