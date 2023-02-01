FROM grafana/promtail:2.3.0

RUN apt-get update && apt-get install --no-install-recommends -y netcat bc curl dumb-init bash procps coreutils vim net-tools && rm -rf /var/lib/apt/lists/*;

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "10", "500" ]
