# escape=`
FROM plugins/base:windows-1903-amd64

LABEL maintainer="Drone.IO Community <drone-dev@googlegroups.com>" `
  org.label-schema.name="Drone S3 Cache" `
  org.label-schema.vendor="Drone.IO Community" `
  org.label-schema.schema-version="1.0"

ADD release/windows/amd64/drone-s3-cache.exe C:/bin/drone-s3-cache.exe
ENTRYPOINT [ "C:\\bin\\drone-s3-cache.exe" ]