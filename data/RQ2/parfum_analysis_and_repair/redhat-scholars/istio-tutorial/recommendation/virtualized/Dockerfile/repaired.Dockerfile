FROM spectolabs/hoverfly:v0.16.0

RUN apt-get update && apt-get install --no-install-recommends -y \
  curl && rm -rf /var/lib/apt/lists/*;

EXPOSE 8080 8888

ADD simulation.json /go/bin

ENTRYPOINT ["/go/bin/hoverfly", "-listen-on-host=0.0.0.0", "-webserver", "-pp=8080"]
CMD [""]