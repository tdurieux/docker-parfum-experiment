FROM taskcat-e2e:latest
MAINTAINER taskcat-dev-team

COPY local-entrypoint.sh /usr/local/bin/

ENV LOCAL_TEST=True

ENTRYPOINT ["local-entrypoint.sh"]