FROM 10.1.127.12:5000/neuvector/enforcer_base

# Dockerfile to create controller+enforcer container image

COPY stage /

LABEL neuvector.image="neuvector/controller+enforcer" \
      neuvector.role="controller+enforcer"

ENTRYPOINT ["/usr/local/bin/monitor", "-d"]