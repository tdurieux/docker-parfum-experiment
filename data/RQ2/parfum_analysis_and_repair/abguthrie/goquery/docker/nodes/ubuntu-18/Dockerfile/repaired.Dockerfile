FROM ubuntu:18.04
LABEL maintainer="obelisk"

RUN mkdir /etc/osquery/
RUN mkdir /var/log/osquery/
RUN apt update && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -# "https://osquery-packages.s3.amazonaws.com/deb/osquery_4.0.2_1.linux.amd64.deb" -o "/tmp/osquery.deb"
RUN dpkg -i "/tmp/osquery.deb"

COPY docker/certs/example_server.crt /etc/osquery/server.crt
COPY docker/config/osquery/osquery.flags /var/osquery/osquery.flags
COPY docker/config/osquery/secret /tmp/secret

ENTRYPOINT [ "/usr/bin/osqueryd" ]

CMD ["--flagfile=/var/osquery/osquery.flags", "--verbose"]

