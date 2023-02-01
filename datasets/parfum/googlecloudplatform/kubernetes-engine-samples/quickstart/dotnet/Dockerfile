# Use Microsoft's official lightweight .NET images.
# https://hub.docker.com/r/microsoft/dotnet

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-alpine AS build
WORKDIR /app

# Install production dependencies.
# Copy csproj and restore as distinct layers.
COPY *.csproj ./
RUN dotnet restore

# Copy local code to the container image.
COPY . ./

# Build a release artifact.
RUN dotnet publish -c Release -o out

# Run the web service on container startup in a lean production image.
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-alpine
WORKDIR /app

COPY --from=build /app/out ./
CMD ["dotnet", "HelloGKE.dll"]
