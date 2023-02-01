# container utilities
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine as utilities

WORKDIR /src
COPY src/Utilities.HttpCheck/Utilities.HttpCheck.csproj ./Utilities.HttpCheck/

WORKDIR /src/Utilities.HttpCheck
RUN dotnet restore

COPY src /src
RUN dotnet publish -c Release -o /out Utilities.HttpCheck.csproj

# app build
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine as builder

WORKDIR /src
COPY src/SignUp.Entities/SignUp.Entities.csproj ./SignUp.Entities/
COPY src/SignUp.Api.ReferenceData/SignUp.Api.ReferenceData.csproj ./SignUp.Api.ReferenceData/

WORKDIR /src/SignUp.Api.ReferenceData
RUN dotnet restore

COPY src /src
RUN dotnet publish -c Release -o /out SignUp.Api.ReferenceData.csproj

# app image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine

EXPOSE 80
WORKDIR /app
ENTRYPOINT ["dotnet", "/app/SignUp.Api.ReferenceData.dll"]

ENV HttpCheck:TargetUrl="http://localhost/api/ready" \
    HttpCheck:Timeout="200"

HEALTHCHECK --start-period=10s --interval=30s CMD ["dotnet", "/app/Utilities.HttpCheck.dll"]

COPY --from=utilities /out/ .
COPY --from=builder /out/ .
COPY ./docker/05-03-deploying-stacks/reference-data-api/appsettings.json .