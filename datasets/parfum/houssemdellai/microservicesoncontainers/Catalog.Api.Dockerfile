FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src

# build HealthChecks
COPY ["/HealthChecks/HealthChecks.csproj", "HealthChecks/"]
RUN dotnet restore "HealthChecks/HealthChecks.csproj"
COPY ["/HealthChecks", "HealthChecks/"]
RUN dotnet build "HealthChecks/HealthChecks.csproj" -c Release

# build Catalog.Api
ARG path="Catalog.Api"
ARG projectPath="Catalog.Api/Catalog.Api.csproj"
COPY ${projectPath} ${projectPath}
RUN dotnet restore ${projectPath}
COPY ${path} ${path}
RUN dotnet build ${projectPath} -c Release -o /app

FROM build AS publish
RUN dotnet publish "Catalog.Api/Catalog.Api.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Catalog.Api.dll"]