# Data
FROM scratch as data
WORKDIR /app
COPY Data/DataCache Data/DataCache
COPY Data/appsettings.json .
COPY Data/DB Data/DB

# Build
FROM mcr.microsoft.com/dotnet/sdk:5.0 as build
WORKDIR /src
COPY RazzleServer.sln ./
COPY RazzleServer/RazzleServer.csproj RazzleServer/
COPY RazzleServer.DataAccess/RazzleServer.DataAccess.csproj RazzleServer.DataAccess/
COPY RazzleServer.DataProvider/RazzleServer.DataProvider.csproj RazzleServer.DataProvider/
COPY RazzleServer.Common/RazzleServer.Common.csproj RazzleServer.Common/
COPY RazzleServer.Login/RazzleServer.Login.csproj RazzleServer.Login/
COPY RazzleServer.Game/RazzleServer.Game.csproj RazzleServer.Game/
COPY RazzleServer.Shop/RazzleServer.Shop.csproj RazzleServer.Shop/
COPY RazzleServer.Crypto/RazzleServer.Crypto.csproj RazzleServer.Crypto/
COPY RazzleServer.Net/RazzleServer.Net.csproj RazzleServer.Net/
COPY RazzleServer.Wz/RazzleServer.Wz.csproj RazzleServer.Wz/
COPY RazzleServer.Tests/RazzleServer.Tests.csproj RazzleServer.Tests/
RUN dotnet restore
COPY . .

# Publish
FROM build AS publish
WORKDIR /src/RazzleServer
RUN dotnet publish -c Release -o /app

# Run
FROM mcr.microsoft.com/dotnet/runtime:5.0 as runtime
WORKDIR /app
COPY --from=publish /app .
COPY --from=data /app .

ENTRYPOINT ["dotnet", "RazzleServer.dll"]