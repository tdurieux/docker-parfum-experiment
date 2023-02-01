FROM ubuntu

ARG REPO_CONFIG=grafana.list.oss
ARG PACKAGE=grafana

COPY sources.list /etc/apt/sources.list
RUN apt update && \
    apt install --no-install-recommends -y curl \
                   apt-transport-https \
                   ca-certificates \
                   gnupg && \
    curl -f https://packages.grafana.com/gpg.key | apt-key add - && rm -rf /var/lib/apt/lists/*;

COPY "./$REPO_CONFIG" /etc/apt/sources.list.d/grafana.list
RUN apt update && \
    apt install --no-install-recommends -y $PACKAGE && rm -rf /var/lib/apt/lists/*;
