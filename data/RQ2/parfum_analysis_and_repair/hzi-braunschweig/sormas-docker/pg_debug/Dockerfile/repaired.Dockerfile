FROM debian:bullseye

RUN apt update && \
    apt upgrade -y && \
    apt install --no-install-recommends -y \
      pgstat \
      pgtop \
      pg-activity && rm -rf /var/lib/apt/lists/*;

CMD [ "sleep", "infinity" ]
