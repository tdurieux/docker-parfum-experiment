FROM totara/docker-dev-php71:latest

RUN apt-get update && apt-get install --no-install-recommends -y cron && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

CMD /entrypoint.sh