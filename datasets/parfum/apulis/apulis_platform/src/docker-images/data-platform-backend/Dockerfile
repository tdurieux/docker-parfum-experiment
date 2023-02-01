#FROM apulistech/build_dotnetcore:0.1
#
#RUN git clone --branch dev https://5ad9420031b357cdd1f9f9cea5022c19c0ea2da1@github.com/aurorazl/RemoteSensing-UI.git /RemoteSensing-UI
#WORKDIR /RemoteSensing-UI/src/projects/WebUI

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
RUN git clone --branch dev https://c754fb803c3f5c7fe91780f1a7222275bea3cbbf@github.com/apulis/data-platform-backend.git /RemoteSensing-UI
WORKDIR /RemoteSensing-UI/src/projects/WebUI/WebUI
RUN dotnet publish --configuration Release

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
WORKDIR /app
COPY --from=build-env /RemoteSensing-UI/src/projects/WebUI/WebUI/bin/Release/netcoreapp2.2/publish .