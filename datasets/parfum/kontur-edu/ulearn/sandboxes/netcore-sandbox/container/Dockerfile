FROM mcr.microsoft.com/dotnet/core/sdk

RUN apt-get -y update
RUN apt-get -y install jq dos2unix

RUN mkdir /app

COPY ./app/ /app/

WORKDIR app

RUN dotnet build packages.csproj

RUN rm packages.csproj