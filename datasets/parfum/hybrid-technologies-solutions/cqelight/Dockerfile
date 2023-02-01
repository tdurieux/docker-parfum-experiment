FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /
USER root
COPY /src /src
COPY /tests /tests
COPY CQELight_CI.sln CQELight_CI.sln
ENTRYPOINT ["dotnet","test"]