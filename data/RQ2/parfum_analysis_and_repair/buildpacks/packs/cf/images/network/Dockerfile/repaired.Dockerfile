ARG stack
FROM packs/${stack}

EXPOSE 8080

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y sshpass && \
  rm -rf /var/lib/apt/lists/*

USER vcap