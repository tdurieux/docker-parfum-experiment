# escape=`
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS builder

WORKDIR C:\src
COPY src\SignUp.Web.sln .
COPY src\SignUp.Core\SignUp.Core.csproj .\SignUp.Core\
COPY src\SignUp.Entities\SignUp.Entities.csproj .\SignUp.Entities\
COPY src\SignUp.Messaging\SignUp.Messaging.csproj .\SignUp.Messaging\
COPY src\SignUp.Model\SignUp.Model.csproj .\SignUp.Model\
COPY src\SignUp.Web\SignUp.Web.csproj .\SignUp.Web\
COPY src\SignUp.Model\packages.config .\SignUp.Model\
COPY src\SignUp.Web\packages.config .\SignUp.Web\
RUN nuget restore SignUp.Web.sln

COPY src C:\src
RUN msbuild SignUp.Web\SignUp.Web.csproj /p:OutputPath=c:\out /p:Configuration=Release

# app image
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV APP_ROOT=C:\web-app
ENTRYPOINT ["powershell", "C:\\start.ps1"]

WORKDIR ${APP_ROOT}
RUN New-WebApplication -Name 'app' -Site 'Default Web Site' -PhysicalPath $env:APP_ROOT

COPY --from=builder C:\out\_PublishedWebsites\SignUp.Web ${APP_ROOT} 
COPY docker\02-06-platform-integration\signup-web\v6\Web.config ${APP_ROOT}
COPY docker\02-06-platform-integration\signup-web\v6\config\*.config ${APP_ROOT}\config\
COPY docker\02-06-platform-integration\signup-web\v6\start.ps1 C:\