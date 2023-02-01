ARG BASE_IMAGE
FROM "$BASE_IMAGE"
  USER root:root
  WORKDIR '/app/'

  COPY 'src/main/docker/stackgres-jobs.jvm.sh' '/app/stackgres-jobs.sh'

  COPY 'target/quarkus-app/lib/' '/app/lib/'
  COPY 'target/quarkus-app/*.jar' '/app/'
  COPY 'target/quarkus-app/app/' '/app/app/'
  COPY 'target/quarkus-app/quarkus/' '/app/quarkus/'

  RUN chown -R jboss:jboss '/app'
  RUN chmod 755 '/app'
  RUN chmod 755 '/app/stackgres-jobs.sh'

  ENV HOME=/app LANG=C.utf8
  USER jboss:jboss
  EXPOSE 8080
  EXPOSE 8443

  CMD '/app/stackgres-jobs.sh'