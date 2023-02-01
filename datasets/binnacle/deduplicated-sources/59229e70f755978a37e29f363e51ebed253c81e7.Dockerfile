# escape=`
FROM plugins/base:windows-amd64

LABEL maintainer="Drone.IO Community <drone-dev@googlegroups.com>" `
  org.label-schema.name="Drone S3" `
  org.label-schema.vendor="Drone.IO Community" `
  org.label-schema.schema-version="1.0"

ADD release\drone-s3.exe c:\drone-s3.exe
ENTRYPOINT [ "c:\\drone-s3.exe" ]
