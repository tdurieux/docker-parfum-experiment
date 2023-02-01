## Get the latest source and extract it for the app container.
## Design choices, two RUN layers intended to keep builds faster, the zipped
FROM ubuntu:18.04 as prep
LABEL MAINTAINER="leopere [at] nixc [dot] us"
RUN apt-get update && \
  apt-get -y --no-install-recommends install unzip curl telnet wait-for-it && \
  apt-get autoclean -y && \
  rm -rf /var/lib/apt/lists/*
WORKDIR /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
COPY ./start.sh start
COPY ./healthcheck.sh healthcheck
ARG VERSION="master"
RUN curl -f -s -o /chainquery https://build.lbry.io/chainquery/branch-"${VERSION}"/chainquery && \
    chmod +x /chainquery


FROM ubuntu:18.04 as app
RUN apt-get update && \
  apt-get -y --no-install-recommends install telnet wait-for-it && \
  apt-get autoclean -y && \
  rm -rf /var/lib/apt/lists/*
ARG VERSION="master"
ADD https://raw.githubusercontent.com/lbryio/chainquery/"${VERSION}"/config/default/chainqueryconfig.toml /etc/lbry/chainqueryconfig.toml.orig
RUN adduser chainquery --gecos GECOS --shell /bin/bash --disabled-password --home /home/chainquery && \
  chown -R chainquery:chainquery /etc/lbry
COPY --from=prep ./healthcheck /chainquery /start /usr/bin/
HEALTHCHECK --interval=1m --timeout=30s \
  CMD healthcheck
EXPOSE 6300
USER chainquery
STOPSIGNAL SIGINT
CMD ["start"]