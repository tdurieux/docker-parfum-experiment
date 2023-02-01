FROM microsoft/aspnetcore-build:2.0 AS build-env
WORKDIR /app

# 拷贝.csproj到工作目录/app，然后执行dotnet restore恢复所有安装的NuGet包。
COPY Library.Service.Handler ./Library.Service.Handler/
COPY Library.Service.Identity.Domain ./Library.Service.Identity.Domain/
COPY Library.Service.Inventory.Domain ./Library.Service.Inventory.Domain/
COPY Library.Service.Rental.Domain ./Library.Service.Rental.Domain/
COPY Library.Infrastructure.InjectionFramework ./Library.Infrastructure.InjectionFramework/
COPY Library.Infrastructure.Core ./Library.Infrastructure.Core/
COPY Library.Domain.Core ./Library.Domain.Core/
COPY Library.Infrastructure.DataPersistence.Core.SQLServer ./Library.Infrastructure.DataPersistence.Core.SQLServer/
COPY Library.Infrastructure.Messaging.SignalR ./Library.Infrastructure.Messaging.SignalR/
COPY Library.Infrastructure.Messaging.RabbitMQ ./Library.Infrastructure.Messaging.RabbitMQ/
COPY Library.Infrastructure.DataPersistence.Inventory.SQLServer ./Library.Infrastructure.DataPersistence.Inventory.SQLServer/
COPY Library.Infrastructure.DataPersistence.Rental.SQLServer ./Library.Infrastructure.DataPersistence.Rental.SQLServer/
COPY Library.Infrastructure.DataPersistence.Identity.SQLServer ./Library.Infrastructure.DataPersistence.Identity.SQLServer/
COPY Library.Infrastructure.EventStorage.MongoDB ./Library.Infrastructure.EventStorage.MongoDB/
COPY Library.Infrastructure.EventStorage.SQLServer ./Library.Infrastructure.EventStorage.SQLServer/
COPY Library.Infrastructure.Logger.SQLServer ./Library.Infrastructure.Logger.SQLServer/
COPY Library.Infrastructure.Operation.Consul ./Library.Infrastructure.Operation.Consul/
COPY Library.Infrastructure.Operation.Core ./Library.Infrastructure.Operation.Core/

WORKDIR /app/Library.Service.Handler
RUN dotnet restore

WORKDIR /app/Library.Service.Handler
RUN dotnet publish -c Release -o out

# 编译Docker镜像
FROM microsoft/aspnetcore:2.0
WORKDIR /app/Library.Service.Handler
COPY --from=build-env /app/Library.Service.Handler/out .
ENTRYPOINT ["dotnet", "Library.Service.Handler.dll"]