FROM golang:1.16
WORKDIR /PipelineRepoServer
COPY . .

FROM alpine:latest
RUN apk update
RUN apk upgrade
RUN apk add --no-cache bash
RUN apk add --no-cache git
COPY --from=0 /PipelineRepoServer/pipelinereposerver /
EXPOSE 8080
CMD ["./pipelinereposerver"]