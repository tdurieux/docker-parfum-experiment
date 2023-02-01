FROM mcr.microsoft.com/dotnet/core/runtime:2.2 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY Services/ECommerce.Shipping.Host/ECommerce.Shipping.Host.csproj Services/ECommerce.Shipping.Host/
COPY Services/ECommerce.Common/ECommerce.Common.csproj Services/ECommerce.Common/
COPY Services/ECommerce.Services.Common/ECommerce.Services.Common.csproj Services/ECommerce.Services.Common/
RUN dotnet restore Services/ECommerce.Shipping.Host/ECommerce.Shipping.Host.csproj
COPY . .
WORKDIR /src/Services/ECommerce.Shipping.Host
RUN dotnet build ECommerce.Shipping.Host.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish ECommerce.Shipping.Host.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ECommerce.Shipping.Host.dll"]
