# escape=`
FROM plugins/base:windows-1803

LABEL maintainer="Drone.IO Community <drone-dev@googlegroups.com>" `
  org.label-schema.name="Drone GitHub Pages" `
  org.label-schema.vendor="Drone.IO Community" `
  org.label-schema.schema-version="1.0"

ADD release/windows/amd64/drone-gh-pages.exe C:/bin/drone-gh-pages.exe
ENTRYPOINT [ "C:\\bin\\drone-gh-pages.exe" ]