FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY GdscBackend/GdscBackend.csproj .
RUN dotnet restore

# Copy everything else and build
COPY GdscBackend ./

RUN dotnet publish GdscBackend.csproj -c Release -o /app/out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .


COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# Link image with github repo
LABEL org.opencontainers.image.source=https://github.com/dsc-upt/gdsc-backend
