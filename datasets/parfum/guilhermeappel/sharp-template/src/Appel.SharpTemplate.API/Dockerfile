#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["src/Appel.SharpTemplate.API/Appel.SharpTemplate.API.csproj", "src/Appel.SharpTemplate.API/"]
COPY ["src/Appel.SharpTemplate.Domain/Appel.SharpTemplate.Domain.csproj", "src/Appel.SharpTemplate.Domain/"]
COPY ["src/Appel.SharpTemplate.Infrastructure/Appel.SharpTemplate.Infrastructure.csproj", "src/Appel.SharpTemplate.Infrastructure/"]
RUN dotnet restore "src/Appel.SharpTemplate.API/Appel.SharpTemplate.API.csproj"
COPY . .
WORKDIR "/src/src/Appel.SharpTemplate.API"
RUN dotnet build "Appel.SharpTemplate.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Appel.SharpTemplate.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ADD /src/Appel.SharpTemplate.Infrastructure/Application/EmailTemplates /app/EmailTemplates/
CMD ASPNETCORE_URLS=http://*:$PORT dotnet Appel.SharpTemplate.API.dll