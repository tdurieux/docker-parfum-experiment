FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build

ENV APP_HOME /opt/app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY PolicyService.Api/*.csproj $APP_HOME/PolicyService.Api/
COPY PolicySearchService.Api/*.csproj $APP_HOME/PolicySearchService.Api/
COPY PolicySearchService/*.csproj $APP_HOME/PolicySearchService/
RUN cd $APP_HOME/PolicySearchService && dotnet restore

COPY PolicyService.Api $APP_HOME/PolicyService.Api/
COPY PolicySearchService.Api $APP_HOME/PolicySearchService.Api/
COPY PolicySearchService $APP_HOME/PolicySearchService/
RUN cd $APP_HOME/PolicySearchService && dotnet build

FROM build AS publish
WORKDIR $APP_HOME/PolicySearchService
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS final
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:5060
ENV ASPNETCORE_ENVIRONMENT=docker
COPY --from=publish /opt/app/PolicySearchService/out ./
ENTRYPOINT ["dotnet", "PolicySearchService.dll"]