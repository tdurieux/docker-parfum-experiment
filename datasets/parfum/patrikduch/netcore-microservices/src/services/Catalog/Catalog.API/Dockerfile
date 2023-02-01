#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk AS build

WORKDIR /src

COPY ["src/services/Catalog/Catalog.API/Catalog.API.csproj", "src/services/Catalog/Catalog.API/"]
COPY ["src/services/Catalog/Catalog.Application/Catalog.Application.csproj", "src/services/Catalog/Catalog.Application/"]
COPY ["src/services/Catalog/Catalog.Domain/Catalog.Domain.csproj", "src/services/Catalog/Catalog.Domain/"]
COPY ["src/services/Catalog/Catalog.Infrastructure/Catalog.Infrastructure.csproj", "src/services/Catalog/Catalog.Infrastructure/"]
COPY ["src/services/Catalog/Catalog.Persistence/Catalog.Persistence.csproj", "src/services/Catalog/Catalog.Persistence/"]

ARG NUGET_PAT

# Set environment variables
ENV NUGET_CREDENTIALPROVIDER_SESSIONTOKENCACHE_ENABLED true
ENV VSS_NUGET_EXTERNAL_FEED_ENDPOINTS '{"endpointCredentials":[{"endpoint":"https://pkgs.dev.azure.com/duchpatrick/netmicroservices/_packaging/NetMicroservices.Messaging/nuget/v3/index.jso","username":"NoRealUserNameAsIsNotRequired","password":"'${NUGET_PAT}'"},{"endpoint":"https://pkgs.dev.azure.com/duchpatrick/netmicroservices/_packaging/NetMicroservices.Dbs/nuget/v3/index.json","username":"NoRealUserNameAsIsNotRequired","password":"'${NUGET_PAT}'"},{"endpoint":"https://pkgs.dev.azure.com/duchpatrick/netmicroservices/_packaging/NetMicroservices.Configuration/nuget/v3/index.json","username":"NoRealUserNameAsIsNotRequired","password":"'${NUGET_PAT}'"}]}'

# Get and install the Artifact Credential provider
RUN wget -O - https://raw.githubusercontent.com/Microsoft/artifacts-credprovider/master/helpers/installcredprovider.sh  | bash

# Restore your nugets from nuget.org and your private feed.
RUN dotnet restore -s "https://pkgs.dev.azure.com/duchpatrick/netmicroservices/_packaging/NetMicroservices.Dbs/nuget/v3/index.json" -s "https://pkgs.dev.azure.com/duchpatrick/netmicroservices/_packaging/NetMicroservices.Messaging/nuget/v3/index.json" -s "https://api.nuget.org/v3/index.json" -s "https://pkgs.dev.azure.com/duchpatrick/netmicroservices/_packaging/NetMicroservices.Configuration/nuget/v3/index.json" "src/services/Catalog/Catalog.API/Catalog.API.csproj"

COPY . .
WORKDIR "/src/src/services/Catalog/Catalog.API"
RUN dotnet build "Catalog.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Catalog.API.csproj" -c Release -o /app/publish 

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Catalog.API.dll"]