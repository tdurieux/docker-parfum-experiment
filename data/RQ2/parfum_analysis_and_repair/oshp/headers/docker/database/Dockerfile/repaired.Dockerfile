FROM mysql:5.5.54

LABEL maintainer="alexandre menezes <alexandre.fmenezes@owasp.org>"

ENV HEADERS_FILE https://s3.amazonaws.com/reports.bsecteam.com/headers.sql

RUN apt-get update && \
  apt-get install --no-install-recommends -y curl && \
  curl -f -o headers.sql $HEADERS_FILE && \
  mv headers.sql /docker-entrypoint-initdb.d/ && rm -rf /var/lib/apt/lists/*;

HEALTHCHECK --timeout=5s --start-period=30s --retries=3 \
  CMD curl localhost:3306 || exit 1

USER mysql
