#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Import/OCM.Import.Worker/OCM.Import.Worker.csproj", "Import/OCM.Import.Worker/"]
RUN dotnet restore "Import/OCM.Import.Worker/OCM.Import.Worker.csproj"
COPY . .
WORKDIR "/src/Import/OCM.Import.Worker"
RUN dotnet build "OCM.Import.Worker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "OCM.Import.Worker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OCM.Import.Worker.dll"]