FROM secrethub/cli:0.40.0

RUN apk add --no-cache sed

COPY entrypoint.sh /entrypoint.sh
COPY app-info.sh /app-info.sh

ENTRYPOINT ["/entrypoint.sh"]
