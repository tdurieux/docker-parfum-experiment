# escape=`
# Simple Dockerfile which copies clr and library build artifacts into target dotnet sdk image
ARG SDK_BASE_IMAGE=mcr.microsoft.com/dotnet/nightly/sdk:6.0-nanoserver-1809
FROM $SDK_BASE_IMAGE as target

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG VERSION=7.0
ENV _DOTNET_INSTALL_CHANNEL="$VERSION.1xx"
ARG CONFIGURATION=Release

USER ContainerAdministrator

RUN Invoke-WebRequest -Uri https://dot.net/v1/dotnet-install.ps1 -OutFile .\dotnet-install.ps1
RUN & .\dotnet-install.ps1 -Channel $env:_DOTNET_INSTALL_CHANNEL -Quality daily -InstallDir 'C:/Program Files/dotnet'

USER ContainerUser

COPY . /live-runtime-artifacts

# Add AspNetCore bits to testhost: