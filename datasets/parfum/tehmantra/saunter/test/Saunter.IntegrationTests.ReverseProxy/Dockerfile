FROM mcr.microsoft.com/dotnet/aspnet:5.0

# Run "dotnet publish -c Release" before building this image
COPY bin/Release/net5.0/publish/ App/

WORKDIR /App

EXPOSE 5000

ENTRYPOINT ["dotnet", "Saunter.IntegrationTests.ReverseProxy.dll"]
