# 1 шаг
FROM golang:1.11.0 AS build_step
COPY ./code /go/src/docker0
RUN CGO_ENABLED=0 go install docker0

# 2 шаг