FROM microsoft/dotnet:2.2-aspnetcore-runtime-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk-stretch AS build
WORKDIR /src
COPY Services/Portfolio/Portfolio.API/Portfolio.API.csproj Services/Portfolio/Portfolio.API/
RUN dotnet restore Services/Portfolio/Portfolio.API/Portfolio.API.csproj
COPY . .
WORKDIR /src/Services/Portfolio/Portfolio.API
RUN dotnet build Portfolio.API.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish Portfolio.API.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Portfolio.API.dll"]