FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
# FROM gcr.io/cloud-builders/go:alpine
# RUN apk update && apk add --no-cache bash git
COPY gopath/bin/mdrip /mdrip
EXPOSE 8080
CMD ["/mdrip",\
    "--alsologtostderr",\
    "--v=0",\
    "--stderrthreshold=INFO",\
    "--port=8080",\
    "--mode=demo",\
    "gh:monopole/snt"]
