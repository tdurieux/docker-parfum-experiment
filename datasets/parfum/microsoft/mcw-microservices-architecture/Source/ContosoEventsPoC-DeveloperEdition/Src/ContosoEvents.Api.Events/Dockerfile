FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["ContosoEvents.Api.Events/ContosoEvents.Api.Events.csproj", "ContosoEvents.Api.Events/"]
RUN dotnet restore "ContosoEvents.Api.Events/ContosoEvents.Api.Events.csproj"
COPY . .
WORKDIR "/src/ContosoEvents.Api.Events"
RUN dotnet build "ContosoEvents.Api.Events.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "ContosoEvents.Api.Events.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ContosoEvents.Api.Events.dll"]