FROM mcr.microsoft.com/dotnet/core/sdk AS build
WORKDIR /app

ARG sln=DShop.Services.Customers.sln
ARG service=src/DShop.Services.Customers
ARG tests=tests/DShop.Services.Customers.Tests
ARG configuration=Release
ARG feed='--source "https://api.nuget.org/v3/index.json"'

COPY ${sln} ./
COPY ./${service} ./${service}/
COPY ./${tests} ./${tests}/

RUN dotnet restore /property:Configuration=${configuration} ${feed}

COPY . ./
RUN dotnet publish ${service} -c ${configuration} -o out ${feed}

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
WORKDIR /app

ARG service=src/DShop.Services.Customers

COPY --from=builder /app/${service}/out/ .

ENV ASPNETCORE_URLS http://*:5000
ENV ASPNETCORE_ENVIRONMENT docker

EXPOSE 5000

ENTRYPOINT dotnet DShop.Services.Customers.dll