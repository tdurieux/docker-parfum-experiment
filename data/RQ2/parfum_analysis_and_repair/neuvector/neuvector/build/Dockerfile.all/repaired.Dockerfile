ARG BASE_PREFIX
FROM 10.1.127.12:5000/neuvector/${BASE_PREFIX}all_base:jdk11

COPY stage /

ARG NV_TAG
LABEL name="allinone" \
      vendor="NeuVector Inc." \
      version=${NV_TAG} \
      release=${NV_TAG} \
      neuvector.image="neuvector/allinone" \
      neuvector.role="controller+enforcer+manager"

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]