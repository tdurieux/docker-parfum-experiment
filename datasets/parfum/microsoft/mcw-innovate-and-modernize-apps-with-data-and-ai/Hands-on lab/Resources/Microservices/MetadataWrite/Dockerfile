FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY ["MetadataWrite/MetadataWrite.csproj", "MetadataWrite/"]
COPY ["Common/Common.csproj", "Common/"]
RUN dotnet restore "MetadataWrite/MetadataWrite.csproj"

# Copy everything else and build
COPY ["MetadataWrite", "MetadataWrite/"]
COPY ["Common", "Common/"]
RUN dotnet publish "MetadataWrite/MetadataWrite.csproj" -c Release -o out
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "MetadataWrite.dll"]