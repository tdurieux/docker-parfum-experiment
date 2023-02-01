FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

COPY . ./
WORKDIR /app/src/WebSite

RUN dotnet restore
RUN dotnet publish -c Release -o /out

# Build runtime image
FROM  mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /out .

EXPOSE 80
ENTRYPOINT ["dotnet", "/app/WebSite.dll"]