FROM microsoft/dotnet:aspnetcore-runtime
COPY . /app
WORKDIR /app
ENTRYPOINT ["dotnet", "Bookshelf.dll"]