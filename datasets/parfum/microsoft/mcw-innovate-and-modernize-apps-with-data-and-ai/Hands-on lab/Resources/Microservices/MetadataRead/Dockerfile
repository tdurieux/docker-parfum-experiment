FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY ["MetadataRead/MetadataRead.csproj", "MetadataRead/"]
COPY ["Common/Common.csproj", "Common/"]
RUN dotnet restore "MetadataRead/MetadataRead.csproj"

# Copy everything else and build
COPY ["MetadataRead", "MetadataRead/"]
COPY ["Common", "Common/"]
RUN dotnet publish "MetadataRead/MetadataRead.csproj" -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "MetadataRead.dll"]