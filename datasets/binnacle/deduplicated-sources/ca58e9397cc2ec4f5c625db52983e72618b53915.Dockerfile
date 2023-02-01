FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY TripTrackerLive.sln ./
COPY TripTracker.BackService/TripTracker.BackService.csproj TripTracker.BackService/
RUN dotnet restore -nowarn:msb3202,nu1503
COPY . .
WORKDIR /src/TripTracker.BackService
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "TripTracker.BackService.dll"]
