﻿# escape=`

ARG BASE_IMAGE
ARG BUILD_IMAGE

FROM ${BUILD_IMAGE} AS prep

# Gather only artifacts necessary for NuGet restore, retaining directory structure
# COPY *.sln nuget.config Directory.Build.targets Packages.props \nuget\
COPY *.sln nuget.config \nuget\
COPY src\ \temp\
RUN Invoke-Expression 'robocopy C:\temp C:\nuget\src /s /ndl /njh /njs *.csproj *.scproj packages.config'

FROM ${BUILD_IMAGE} AS builder

ARG BUILD_CONFIGURATION

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Create an empty working directory
WORKDIR C:\build

# Copy prepped NuGet artifacts, and restore as distinct layer to take better advantage of caching
COPY --from=prep .\nuget .\
RUN nuget restore

# Copy remaining source code
COPY src\ .\src\

# Copy transforms, retaining directory structure
RUN Invoke-Expression 'robocopy C:\build\src C:\out\transforms /s /ndl /njh /njs *.xdt'

# Build website with file publish
RUN msbuild .\src\Feature\FormsExtensions\code\Feature.FormsExtensions.csproj /p:Configuration=$env:BUILD_CONFIGURATION /p:DeployOnBuild=True /p:DeployDefaultTarget=WebPublish /p:WebPublishMethod=FileSystem /p:PublishProfile=03_Docker /p:PublishUrl=C:\out\website
RUN msbuild .\src\Project\FormsExtensionsTester\code\Project.FormsExtensionsTester.csproj /p:Configuration=$env:BUILD_CONFIGURATION /p:DeployOnBuild=True /p:DeployDefaultTarget=WebPublish /p:WebPublishMethod=FileSystem /p:PublishProfile=03_Docker /p:PublishUrl=C:\out\website

FROM ${BASE_IMAGE}

WORKDIR C:\artifacts

# Copy final build artifacts
COPY --from=builder C:\out\website .\website\
COPY --from=builder C:\out\transforms .\transforms\
#COPY --from=builder C:\out\xconnect .\xconnect\