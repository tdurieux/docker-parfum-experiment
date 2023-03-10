# escape=`
FROM plugins/base:windows-2004-amd64

LABEL maintainer="Drone.IO Community <drone-dev@googlegroups.com>" `
  org.label-schema.name="Drone GitHub Release" `
  org.label-schema.vendor="Drone.IO Community" `
  org.label-schema.schema-version="1.0"

ADD release/windows/amd64/drone-github-release.exe C:/bin/drone-github-release.exe
ENTRYPOINT [ "C:\\bin\\drone-github-release.exe" ]