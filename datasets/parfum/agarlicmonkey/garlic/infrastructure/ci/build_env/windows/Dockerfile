# escape=`

FROM mcr.microsoft.com/windows/servercore:1809

SHELL ["cmd", "/S", "/C"]

#Get chocolatey
RUN powershell -Command iex ((new-object net.webclient).DownloadString(‘https://chocolatey.org/install.ps1‘));

#Install environment
RUN choco install -y git
RUN choco install -y cmake.install --installargs '"ADD_CMAKE_TO_PATH=System"'
RUN choco install -y python
RUN choco install -y conan

#Install build tools
RUN choco install -y visualstudio2019buildtools || IF "%ERRORLEVEL%"=="3010" EXIT 0

#Install vulkan
RUN choco install -y vulkan-sdk

CMD ["powershell.exe"]