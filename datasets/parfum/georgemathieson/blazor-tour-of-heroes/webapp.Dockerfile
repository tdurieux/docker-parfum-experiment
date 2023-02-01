FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /app
COPY src/TourOfHeroes.Web ./TourOfHeroes.Web
RUN dotnet publish TourOfHeroes.Web/*.csproj -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./
ENTRYPOINT ["dotnet", "TourOfHeroes.Web.dll"]
