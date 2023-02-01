FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY ["MachineTelemetryRead/MachineTelemetryRead.csproj", "MachineTelemetryRead/"]
COPY ["Common/Common.csproj", "Common/"]
RUN dotnet restore "MachineTelemetryRead/MachineTelemetryRead.csproj"

# Copy everything else and build
COPY ["MachineTelemetryRead", "MachineTelemetryRead/"]
COPY ["Common", "Common/"]
RUN dotnet publish "MachineTelemetryRead/MachineTelemetryRead.csproj" -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "MachineTelemetryRead.dll"]