# Run vmpooler in a Docker container!  Configuration can either be embedded
# and built within the current working directory, or stored in a
# VMPOOLER_CONFIG environment value and passed to the Docker daemon.
#
# BUILD:
#   docker build -t vmpooler .
#
# RUN:
#   docker run -e VMPOOLER_CONFIG -p 80:4567 -it vmpooler

FROM jruby:9.2-jdk

COPY docker/docker-entrypoint.sh /usr/local/bin/
COPY ./ ./

ENV RACK_ENV=production

RUN gem install bundler && bundle && gem build vmpooler.gemspec && gem install vmpooler*.gem && \
      chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
