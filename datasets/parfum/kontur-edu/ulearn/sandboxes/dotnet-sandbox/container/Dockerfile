FROM mcr.microsoft.com/dotnet/sdk

RUN apt-get -y update
RUN apt-get -y install jq dos2unix
RUN apt-get update && apt-get install -y libgdiplus

RUN mkdir /app

COPY ./app/ /app/

WORKDIR app

RUN dotnet build packages.csproj

RUN rm packages.csproj