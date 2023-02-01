# stage 1 - build the source
from microsoft/dotnet:2.2-sdk-alpine as builder
workdir /sln
copy . .
run dotnet restore
run dotnet publish -c Release
entrypoint bash


# stage 2 - run the result