FROM microsoft/aspnetcore-build:2.0-nanoserver-1709

RUN mkdir c:\src
RUN mkdir c:\app

VOLUME c:\\src
VOLUME c:\\app

WORKDIR /src

RUN dotnet build Codex.Web.Mvc/Codex.Web.Mvc.csproj -c Debug
RUN dotnet publish Codex.Web.Mvc/Codex.Web.Mvc.csproj -c Debug -o /app