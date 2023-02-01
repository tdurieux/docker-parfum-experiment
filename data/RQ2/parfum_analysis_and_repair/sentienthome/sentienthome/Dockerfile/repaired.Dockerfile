FROM python:3-onbuild

MAINTAINER https://github.com/fxstein

RUN apt-get update && apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/log/supervisor

EXPOSE 9001 8888
CMD ["/usr/bin/supervisord"]
