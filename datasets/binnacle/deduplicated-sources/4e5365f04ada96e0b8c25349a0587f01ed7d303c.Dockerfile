# escape=`
FROM dockersamples/mta-dev-web-builder:4.7.1 AS builder

WORKDIR C:\src\SignUp.Web
COPY signup\src\SignUp.Web\packages.config .
RUN nuget restore packages.config -PackagesDirectory ..\packages

COPY signup\src C:\src
RUN msbuild SignUp.Web.csproj /p:OutputPath=c:\out /p:DeployOnBuild=true

# perf counter exporter
FROM dockersamples/aspnet-monitoring-exporter AS exporter

# app image
FROM microsoft/aspnet:4.7.1-windowsservercore-ltsc2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Remove-Website -Name 'Default Web Site';`
    New-Item -Path 'C:\web-app' -Type Directory; `
    New-Website -Name 'web-app' -Port 80 -PhysicalPath 'C:\web-app'

HEALTHCHECK --interval=5s `
 CMD powershell -command `
    try { `
     $response = iwr http://localhost/SignUp -UseBasicParsing; `
     if ($response.StatusCode -eq 200) { return 0} `
     else {return 1}; `
    } catch { return 1 }

ENV MESSAGE_QUEUE_URL="nats://message-queue:4222" `
    DB_MAX_RETRY_COUNT="5" `
    DB_MAX_DELAY_SECONDS="10" `
    COLLECTOR_CONFIG_PATH="w3svc-collectors.json"

WORKDIR C:\aspnet-exporter
ENTRYPOINT ["powershell", "C:\\bootstrap.ps1"]

COPY .\part-4\web-1.4\bootstrap.ps1 C:\
COPY --from=exporter C:\aspnet-exporter .
COPY --from=builder C:\out\_PublishedWebsites\SignUp.Web C:\web-app