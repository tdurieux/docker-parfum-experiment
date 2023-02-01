FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["ContosoEvents.Api.Orders/ContosoEvents.Api.Orders.csproj", "ContosoEvents.Api.Orders/"]
RUN dotnet restore "ContosoEvents.Api.Orders/ContosoEvents.Api.Orders.csproj"
COPY . .
WORKDIR "/src/ContosoEvents.Api.Orders"
RUN dotnet build "ContosoEvents.Api.Orders.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "ContosoEvents.Api.Orders.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ContosoEvents.Api.Orders.dll"]