FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /app

COPY ./examples/hello-example/*.csproj ./examples/hello-example/
COPY ./src/wyvern.api/*.csproj ./src/wyvern.api/
COPY ./src/wyvern.entity/*.csproj ./src/wyvern.entity/
COPY ./src/wyvern.utils/*.csproj ./src/wyvern.utils/
COPY ./src/wyvern.visualize/*.csproj ./src/wyvern.visualize/

RUN cd ./examples/hello-example/ && \
    dotnet restore

COPY ./examples/hello-example ./examples/hello-example/
COPY ./src ./src/

RUN cd ./examples/hello-example/ && \
    dotnet publish -o out

COPY ./docker/seed/akka.overrides.conf ./examples/hello-example/out/

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
WORKDIR /app
COPY --from=build-env /app/examples/hello-example/out .
ENTRYPOINT ["dotnet", "wyvern.api.hello.dll"]
