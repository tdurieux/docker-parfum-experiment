# escape=`
FROM plugins/base:windows-amd64

LABEL maintainer="Drone.IO Community <drone-dev@googlegroups.com>" `
  org.label-schema.name="Drone Volume Cache" `
  org.label-schema.vendor="Drone.IO Community" `
  org.label-schema.schema-version="1.0"

ADD release\drone-volume-cache.exe c:\drone-volume-cache.exe
ENTRYPOINT [ "c:\\drone-volume-cache.exe" ]