#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

#FROM registry.cn-hangzhou.aliyuncs.com/masa/dotnet_sdk:6.0.100
#ENV LANG="zh_CN.UTF-8"
#ENV LANGUAGE="zh_CN:zh"
#ENV ASPNETCORE_URLS=http://0.0.0.0:80
#WORKDIR /app
#COPY . .
#RUN dotnet build src/Web/Masa.Auth.Web.Admin.Server -c Release
#ENTRYPOINT ["dotnet","./src/Web/Masa.Auth.Web.Admin.Server/bin/Release/net6.0/Masa.Auth.Web.Admin.Server.dll"]