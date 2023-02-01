FROM debian:stretch
RUN apt-get -y update && apt-get -y --no-install-recommends install ca-certificates curl && apt-get -y clean && rm -rf /var/lib/apt/lists/*;
RUN curl -sSfL https://dl.k8s.io/v1.10.13/kubernetes-client-linux-amd64.tar.gz | tar -C /bin -zx --strip-components=3
ADD tenant-ctl /bin/
ENTRYPOINT ["/bin/tenant-ctl"]
