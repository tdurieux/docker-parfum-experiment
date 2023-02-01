FROM ubuntu

RUN apt-get update && \
    apt-get install --no-install-recommends -y inotify-tools && \
    apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

COPY wather.sh ws.sh

CMD sh ws.sh