﻿FROM microsoft/dotnet:2.1-aspnetcore-runtime
WORKDIR /app
COPY . .
EXPOSE 80
ENTRYPOINT ["dotnet", "AspNetCore.Docker.dll"]
