ARG BASE_IMAGE
FROM "$BASE_IMAGE"
  USER root:root
  WORKDIR '/app/'

  RUN echo 'jboss:x:1000:' >> /etc/group && \
    echo 'jboss:!::' >> /etc/gshadow && \
    echo 'jboss:x:1000:1000::/app:/bin/bash' >> /etc/passwd && \
    echo 'jboss:!!:18655:0:99999:7:::' >> /etc/shadow && \
    echo 'jboss:100000:65536' >> /etc/subgid

  COPY 'src/main/docker/stackgres-restapi.native.sh' '/app/stackgres-restapi.sh'
  COPY 'target/stackgres-restapi-runner' '/app/stackgres-restapi'

  RUN chown -R jboss:jboss '/app'
  RUN chmod 755 '/app'
  RUN chmod 755 '/app/stackgres-restapi.sh'

  ENV HOME=/app LANG=C.utf8
  USER jboss:jboss
  EXPOSE 8080
  EXPOSE 8443

  CMD '/app/stackgres-restapi.sh'