FROM jap:latest
MAINTAINER Sam Whited <swhited@atlassian.com>

RUN apt-get update && apt-get -y --no-install-recommends --force-yes install awscli && rm -rf /var/lib/apt/lists/*;

COPY secrets-entrypoint /secrets-entrypoint
RUN chmod +x /secrets-entrypoint

ENTRYPOINT ["/secrets-entrypoint"]
CMD ["dumb-init", "jap", "-http=:8080"]
