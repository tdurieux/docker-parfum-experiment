FROM ubuntu:18.04
LABEL maintainer="cncf-falco-dev@lists.cncf.io"

ARG FALCO_VERSION=
RUN test -n FALCO_VERSION
ENV FALCO_VERSION ${FALCO_VERSION}

RUN apt update -y && apt install --no-install-recommends dkms curl -y && rm -rf /var/lib/apt/lists/*;

ADD falco-${FALCO_VERSION}-*.tar.gz /
RUN cp -R /falco-${FALCO_VERSION}-$(uname -m)/* /

# Change the falco config within the container to enable ISO 8601 output.
RUN sed -e 's/time_format_iso_8601: false/time_format_iso_8601: true/' < /etc/falco/falco.yaml > /etc/falco/falco.yaml.new \
    && mv /etc/falco/falco.yaml.new /etc/falco/falco.yaml

COPY rules/*.yaml /rules/
COPY trace_files/*.scap /traces/

CMD ["/usr/bin/falco"]
