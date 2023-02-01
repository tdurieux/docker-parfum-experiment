FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y \
  curl && rm -rf /var/lib/apt/lists/*;

ADD traceloop /bin/
CMD ["/bin/traceloop", "k8s"]
