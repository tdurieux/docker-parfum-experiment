FROM ubuntu:trusty
MAINTAINER Simon Johansson <simon.johansson@springer.com>

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
ADD dist/firehose-to-syslog-linux64 /

ENTRYPOINT ["/firehose-to-syslog-linux64"]
CMD ["--help"]
