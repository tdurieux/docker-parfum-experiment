
FROM mcr.microsoft.com/dotnet/sdk:5.0 as build
RUN apt-get update \
  && apt-get install -y --allow-unauthenticated \
    libc6-dev \
    libgdiplus \
    libx11-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY ["src/", "src/"]
COPY BoardGames.sln .
RUN dotnet build -c:Debug
RUN dotnet build -c:Release --no-restore
RUN dotnet publish -c:Release --no-build --no-restore src/Host/Host.csproj

FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine as runtime
RUN apk add icu-libs libx11-dev
RUN apk add libgdiplus-dev \
  --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
WORKDIR /app
COPY --from=build /app/src/Host/bin/Release/net5.0/publish .

FROM build as app_debug
WORKDIR /app/src/Host/bin/Debug/net5.0
ENTRYPOINT ["dotnet", "BoardGames.Host.dll"]

FROM runtime as app_release
WORKDIR /app
ENTRYPOINT ["dotnet", "BoardGames.Host.dll"]

FROM runtime as app_ws
ARG BOARDGAMES__USEPOSTGRESQL
ARG BOARDGAMES__GITHUBCLIENTSECRET
ARG BOARDGAMES__GITHUBCLIENTID
ARG BOARDGAMES__MICROSOFTCLIENTSECRET
ARG BOARDGAMES__MICROSOFTCLIENTID
ENV BoardGames__AssumeHttps true
ENV BoardGames__UsePostgreSql $BOARDGAMES__USEPOSTGRESQL
ENV BoardGames__GitHubClientSecret $BOARDGAMES__GITHUBCLIENTSECRET
ENV BoardGames__GitHubClientId $BOARDGAMES__GITHUBCLIENTID
ENV BoardGames__MicrosoftClientSecret $BOARDGAMES__MICROSOFTCLIENTSECRET
ENV BoardGames__MicrosoftClientId $BOARDGAMES__MICROSOFTCLIENTID
WORKDIR /app
ENTRYPOINT ["dotnet", "BoardGames.Host.dll"]
