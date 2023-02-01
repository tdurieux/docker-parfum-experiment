FROM debian:9

RUN apt-get update && apt-get install --no-install-recommends -y apache2-utils curl && rm -rf /var/lib/apt/lists/*;

ADD ./ab-with-backoff.sh ./ab-with-backoff.sh
