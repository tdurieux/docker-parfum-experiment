# escape=`
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS builder

WORKDIR C:\src
COPY src\SignUp.sln .
COPY src\SignUp.Core\SignUp.Core.csproj .\SignUp.Core\
COPY src\SignUp.Entities\SignUp.Entities.csproj .\SignUp.Entities\
COPY src\SignUp.Messaging\SignUp.Messaging.csproj .\SignUp.Messaging\
COPY src\SignUp.Model\SignUp.Model.csproj .\SignUp.Model\
COPY src\SignUp.Model\packages.config .\SignUp.Model\
COPY src\SignUp.MessageHandlers.SaveProspect\SignUp.MessageHandlers.SaveProspect.csproj .\SignUp.MessageHandlers.SaveProspect\
COPY src\SignUp.MessageHandlers.SaveProspect\packages.config .\SignUp.MessageHandlers.SaveProspect\
RUN nuget restore .\SignUp.sln

COPY src C:\src
RUN msbuild SignUp.MessageHandlers.SaveProspect\SignUp.MessageHandlers.SaveProspect.csproj /p:OutputPath=c:\out\save-prospect\SaveProspectHandler

# app image
FROM mcr.microsoft.com/dotnet/framework/runtime:4.8

ENV APP_ROOT=C:\save-prospect-handler

WORKDIR ${APP_ROOT}
CMD .\SignUp.MessageHandlers.SaveProspect.exe

COPY --from=builder C:\out\save-prospect\SaveProspectHandler .
COPY docker\03-05-backend-async-messaging\save-handler\App.config ${APP_ROOT}\SignUp.MessageHandlers.SaveProspect.exe.config
COPY docker\03-05-backend-async-messaging\save-handler\config\*.config ${APP_ROOT}\config\