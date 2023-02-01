FROM node:16-alpine

USER root
WORKDIR /app
COPY ./ ./board

RUN apk add --no-cache tzdata \
    && apk add --no-cache sed

EXPOSE 8000

ENTRYPOINT ["/app/board/docker/docker_entry.sh"]

CMD ["primary"]
