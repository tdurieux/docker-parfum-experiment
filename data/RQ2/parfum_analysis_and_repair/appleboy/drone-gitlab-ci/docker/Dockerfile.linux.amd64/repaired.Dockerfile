FROM plugins/base:linux-amd64

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>" \
  org.label-schema.name="Drone GitLab CI" \
  org.label-schema.vendor="Bo-Yi Wu" \
  org.label-schema.schema-version="1.0"

COPY release/linux/amd64/drone-gitlab-ci /bin/

ENTRYPOINT ["/bin/drone-gitlab-ci"]