FROM microsoft/aspnetcore-build:2.0 AS build-env
WORKDIR /app

# 拷贝.csproj到工作目录/app，然后执行dotnet restore恢复所有安装的NuGet包。
COPY Library.ApiGateway ./Library.ApiGateway/


WORKDIR /app/Library.ApiGateway
RUN dotnet restore

WORKDIR /app/Library.ApiGateway
RUN dotnet publish -c Release -o out

# 编译Docker镜像
FROM microsoft/aspnetcore:2.0
WORKDIR /app/Library.ApiGateway
COPY --from=build-env /app/Library.ApiGateway/out .
ENTRYPOINT ["dotnet", "Library.ApiGateway.dll"]