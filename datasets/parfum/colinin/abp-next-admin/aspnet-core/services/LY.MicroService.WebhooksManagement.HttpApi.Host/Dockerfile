﻿FROM mcr.microsoft.com/dotnet/aspnet:6.0
LABEL maintainer="colin.in@foxmail.com"
WORKDIR /app

COPY . /app

## Beijing time, self replacement
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone

EXPOSE 80/tcp
VOLUME [ "./app/Logs" ]
VOLUME [ "./app/Modules" ]

ENTRYPOINT ["dotnet", "LY.MicroService.WebhooksManagement.HttpApi.Host.dll"]
