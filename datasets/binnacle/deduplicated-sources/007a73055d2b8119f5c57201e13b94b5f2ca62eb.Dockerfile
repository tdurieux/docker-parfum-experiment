FROM windowsservercore:10.0.14300.1000

MAINTAINER Buc Rogers

# use chocolatey pkg mgr to facilitate downloading jdk without prompting
RUN @powershell -NoProfile -ExecutionPolicy unrestricted -Command "(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

# install jdk8
RUN choco install jdk8 -y


