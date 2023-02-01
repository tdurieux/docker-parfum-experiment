FROM pollendina/debianopenssl:jessie

MAINTAINER Pollendina <https://github.com/allingeek/pollendina>

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

COPY pollendina.sh /certs/pollendina.sh
RUN chmod +x /certs/pollendina.sh

ENTRYPOINT ["/certs/pollendina.sh"]