FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env

FROM build-env as build
WORKDIR /app
RUN apt-get install -y curl \
	&& curl -sL https://deb.nodesource.com/setup_12.x | bash - \
	&& apt-get install -y nodejs \
	&& curl -L https://npmjs.com/install.sh | sh
ENTRYPOINT ["dotnet", "run", "--project", "SynapseInnovateMcwWebapp/SynapseInnovateMcwWebapp.csproj"]

FROM build as publish
# Copy csproj and restore as distinct layers
COPY ["SynapseInnovateMcwWebapp/SynapseInnovateMcwWebapp.csproj", "SynapseInnovateMcwWebapp/"]
COPY ["Common/Common.csproj", "Common/"]
RUN dotnet restore "SynapseInnovateMcwWebapp/SynapseInnovateMcwWebapp.csproj"

# Copy everything else and build
COPY ["SynapseInnovateMcwWebapp", "SynapseInnovateMcwWebapp/"]
COPY ["Common", "Common/"]
RUN dotnet publish "SynapseInnovateMcwWebapp/SynapseInnovateMcwWebapp.csproj" -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=publish /app/out .
ENTRYPOINT ["dotnet", "SynapseInnovateMcwWebapp.dll"]