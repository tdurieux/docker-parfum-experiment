#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

#这种模式是直接在构建镜像的内部编译发布dotnet项目。
#注意下容器内输出端口是9291
#如果你想先手动dotnet build成可执行的二进制文件，然后再构建镜像，请看.Api层下的dockerfile。


FROM mcr.microsoft.com/dotnet/aspnet:6.0-bullseye-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0-bullseye-slim AS build
WORKDIR /src
COPY ["Blog.Core.Api/Blog.Core.Api.csproj", "Blog.Core.Api/"]
COPY ["Blog.Core.Extensions/Blog.Core.Extensions.csproj", "Blog.Core.Extensions/"]
COPY ["Blog.Core.Tasks/Blog.Core.Tasks.csproj", "Blog.Core.Tasks/"]
COPY ["Blog.Core.IServices/Blog.Core.IServices.csproj", "Blog.Core.IServices/"]
COPY ["Blog.Core.Model/Blog.Core.Model.csproj", "Blog.Core.Model/"]
COPY ["Blog.Core.Common/Blog.Core.Common.csproj", "Blog.Core.Common/"]
COPY ["Blog.Core.Services/Blog.Core.Services.csproj", "Blog.Core.Services/"]
COPY ["Blog.Core.Repository/Blog.Core.Repository.csproj", "Blog.Core.Repository/"]
COPY ["Blog.Core.EventBus/Blog.Core.EventBus.csproj", "Blog.Core.EventBus/"]
RUN dotnet restore "Blog.Core.Api/Blog.Core.Api.csproj"
COPY . .
WORKDIR "/src/Blog.Core.Api"
RUN dotnet build "Blog.Core.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Blog.Core.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 9291 
ENTRYPOINT ["dotnet", "Blog.Core.Api.dll"]
