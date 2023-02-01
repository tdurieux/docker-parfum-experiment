FROM python:3.7-bullseye

RUN apt-get update -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y sqlite3 && rm -rf /var/lib/apt/lists/*;

COPY ./entrypoint.sh ./

ENTRYPOINT ["/entrypoint.sh"]
