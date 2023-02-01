FROM golang:1.8-windowsservercore AS build
RUN mv /go /go1.8.1
WORKDIR /
RUN git clone https://github.com/golang/go
WORKDIR /go/src
ENV GOROOT_BOOTSTRAP C:/go1.8.1
ENV CGO_ENABLED 0
RUN cmd /C make.bat

FROM mcr.microsoft.com/windows/nanoserver:10.0.14393.2068
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV GOPATH C:\\gopath
RUN $newPath = ('{0}\bin;C:\go\bin;{1}' -f $env:GOPATH, $env:PATH); \
  Write-Host ('Updating PATH: {0}' -f $newPath); \
  setx /M PATH $newPath;
COPY --from=build /go /go
WORKDIR $GOPATH

ENV GIT_VERSION 2.13.0
ENV GIT_DOWNLOAD_URL https://github.com/git-for-windows/git/releases/download/v${GIT_VERSION}.windows.1/MinGit-${GIT_VERSION}-64-bit.zip
ENV GIT_SHA256 20acda973eca1df056ad08bec6e05c3136f40a1b90e2a290260dfc36e9c2c800

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; \
    Invoke-WebRequest -UseBasicParsing $env:GIT_DOWNLOAD_URL -OutFile git.zip; \
    if ((Get-FileHash git.zip -Algorithm sha256).Hash -ne $env:GIT_SHA256) {exit 1} ; \
    Expand-Archive git.zip -DestinationPath C:\git; \
    Remove-Item git.zip; \
    Write-Host 'Updating PATH ...'; \
    $env:PATH = 'C:\git\cmd;C:\git\mingw64\bin;C:\git\usr\bin;' + $env:PATH; \
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' -Name Path -Value $env:PATH
