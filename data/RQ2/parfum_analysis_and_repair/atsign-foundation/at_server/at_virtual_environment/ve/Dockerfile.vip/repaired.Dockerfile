FROM dart:2.17.5 AS buildimage
ENV USER_ID=1024
ENV GROUP_ID=1024
WORKDIR /app
# Context for this Dockerfile needs to be at_server repo root
# If building manually then (from the repo root):
## sudo docker build -t atsigncompany/virtualenv:vip \
##   -f at_virtual_environment/ve/Dockerfile.vip .
COPY . .
RUN \
  cd /app/at_secondary/at_persistence_secondary_server ; \
  dart pub get ; \
  dart pub update ; \
  cd /app/at_secondary/at_secondary_server ; \
  dart pub get ; \
  dart pub update ; \
  dart compile exe bin/main.dart -o secondary

FROM atsigncompany/vebase:latest
USER root

# Secondary binary and pubspec.yaml from first stage
COPY --from=buildimage --chown=atsign:atsign \
  /app/at_secondary/at_secondary_server/secondary /atsign/secondary/
COPY --from=buildimage --chown=atsign:atsign \
  /app/at_secondary/at_secondary_server/pubspec.yaml /atsign/secondary/

EXPOSE 64 6379 9001

# Run supervisor configuration file on container startup
CMD ["supervisord", "-n"]