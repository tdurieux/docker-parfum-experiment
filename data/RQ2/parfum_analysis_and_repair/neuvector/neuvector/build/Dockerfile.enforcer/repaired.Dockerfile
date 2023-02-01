ARG BASE_PREFIX
FROM 10.1.127.12:5000/neuvector/${BASE_PREFIX}enforcer_base

COPY stage /

# Labels for redhat
ARG NV_TAG
LABEL name="enforcer" \
      vendor="NeuVector Inc." \
      version=${NV_TAG} \
      release=${NV_TAG} \
      neuvector.image="neuvector/enforcer" \
      neuvector.role="enforcer" \
	  neuvector.rev="git.xxxx"

ENTRYPOINT ["/usr/local/bin/monitor", "-r"]