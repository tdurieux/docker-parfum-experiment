# escape=`
FROM plugins/base:windows-1809-amd64

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

LABEL maintainer="Drone.IO Community <drone-dev@googlegroups.com>" `
  org.label-schema.name="Drone Manifest" `
  org.label-schema.vendor="Drone.IO Community" `
  org.label-schema.schema-version="1.0"

ENV MANIFEST_TOOL_VERSION 0.9.0

RUN New-Item -ItemType directory -Path 'C:/bin'; `
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest ('https://github.com/estesp/manifest-tool/releases/download/v{0}/manifest-tool-windows-amd64.exe' -f $env:MANIFEST_TOOL_VERSION) -OutFile 'C:/bin/manifest-tool.exe';

ADD release/windows/amd64/drone-manifest.exe C:/bin/drone-manifest.exe
ENTRYPOINT [ "C:\\bin\\drone-manifest.exe" ]
