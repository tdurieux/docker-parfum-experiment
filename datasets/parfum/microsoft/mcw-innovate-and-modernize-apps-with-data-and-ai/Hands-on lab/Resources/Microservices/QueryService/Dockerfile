FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY ["QueryService/QueryService.csproj", "QueryService/"]
COPY ["Common/Common.csproj", "Common/"]
RUN dotnet restore "QueryService/QueryService.csproj"

# Copy everything else and build
COPY ["QueryService", "QueryService/"]
COPY ["Common", "Common/"]
RUN dotnet publish "QueryService/QueryService.csproj" -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "QueryService.dll"]