ARG BASE_PREFIX
FROM 10.1.127.12:5000/neuvector/${BASE_PREFIX}controller_base

COPY stage /

LABEL name="controller" \
      vendor="NeuVector Inc." \
      version=${NV_TAG} \
      release=${NV_TAG} \
      neuvector.image="neuvector/controller" \
      neuvector.role="controller" \
	  neuvector.rev="git.xxxx"


ENTRYPOINT ["/usr/local/bin/monitor", "-c"]