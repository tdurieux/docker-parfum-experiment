FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
COPY ./ /src
COPY nuget.config /root/.nuget/NuGet/NuGet.Config

WORKDIR /src/Sample/Sample.CommandServiceCore
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "Sample.CommandServiceCore.dll"]
