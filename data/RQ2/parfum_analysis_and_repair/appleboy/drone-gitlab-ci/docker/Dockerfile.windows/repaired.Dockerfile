FROM plugins/base:windows-amd64

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>" \
  org.label-schema.name="Drone GitLab CI" \
  org.label-schema.vendor="Bo-Yi Wu" \
  org.label-schema.schema-version="1.0"

COPY release/drone-gitlab-ci.exe /drone-gitlab-ci.exe

ENTRYPOINT [ "\\drone-gitlab-ci.exe" ]