FROM alpine:latest

RUN apk update && apk add --no-cache bash

COPY ./dist/task_linux_amd64_v1/task assistant-task
CMD ["./assistant-task"]
