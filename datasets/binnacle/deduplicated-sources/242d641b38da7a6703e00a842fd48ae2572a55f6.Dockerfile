# escape=`

# LTSC (Long Term Service Channel) release of Server Core 2019
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# set RUN commands to use powershell
SHELL ["powershell"]

# Note: keep installed dependencies in-sync with Install-RStudio-Prereqs.ps1 for consistency
# between dev machines and the build machine.

# install chocolatey
RUN [System.Net.ServicePointManager]::SecurityProtocol = 3072 -bor 768 -bor 192 -bor 48; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# install some deps via chocolatey
RUN choco install -y cmake --installargs 'ADD_CMAKE_TO_PATH=""System""' --fail-on-error-output; ` 
  choco install -y jdk8; `
  choco install -y -i ant; `
  choco install -y windows-sdk-10.1 --version 10.1.17134.12; `
  choco install -y 7zip; `
  choco install -y nsis
  
RUN choco install -y visualstudio2017buildtools --version 15.8.2.0; `
  choco install -y visualstudio2017-workload-vctools --version 1.3.0
  
# install aws cli
RUN choco install -y awscli

# we use "R" for its real purpose, remove the Invoke-History powershell alias
RUN "echo 'Remove-Item alias:r' | Out-File $PsHome\Profile.ps1"

# install R to c:\R, a common c:\Program issue appears to only happen when installing in docker
RUN $ErrorActionPreference = 'Stop' ;`
  [System.Net.ServicePointManager]::SecurityProtocol = 3072 -bor 768 -bor 192 -bor 48; `
  (New-Object System.Net.WebClient).DownloadFile('https://cran.rstudio.com/bin/windows/base/old/3.0.3/R-3.0.3-win.exe', 'c:\R-3.0.3-win.exe') ;`
  Start-Process c:\R-3.0.3-win.exe -Wait -ArgumentList '/VERYSILENT /DIR="C:\R\R-3.0.3\"' ;`
  Remove-Item c:\R-3.0.3-win.exe -Force

# add R to path
RUN $env:path += ';C:\R\R-3.0.3\bin\i386\' ;`
  [Environment]::SetEnvironmentVariable('Path', $env:path, [System.EnvironmentVariableTarget]::Machine);

# install qt (note that we are using the current directory's context)
RUN [System.Net.ServicePointManager]::SecurityProtocol = 3072 -bor 768 -bor 192 -bor 48; ` 
  (New-Object System.Net.WebClient).DownloadFile('https://s3.amazonaws.com/rstudio-buildtools/QtSDK-5.12.1-msvc2017_64.7z', 'c:\QtSDK-5.12.1-msvc2017_64.7z'); `
  7z x c:\QtSDK-5.12.1-msvc2017_64.7z -oc:\ ; `
  Remove-Item c:\QtSDK-5.12.1-msvc2017_64.7z -Force
    
# cpack (an alias from chocolatey) and cmake's cpack conflict.
RUN Remove-Item -Force 'C:\ProgramData\chocolatey\bin\cpack.exe'

#### this docker container will currently be used as a jenkins swarm slave, rather than instantiated on a swarm ####
##### the items below this are dependencies relevant to jenkins-swarm. #####
##### follow https://issues.jenkins-ci.org/browse/JENKINS-36776 to track docker windows support on jenkins #####

RUN choco install -y git
ENV JENKINS_SWARM_VERSION 3.15
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; `
  Invoke-WebRequest $('https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/{0}/swarm-client-{0}.jar' -f $env:JENKINS_SWARM_VERSION) -OutFile 'C:\swarm-client.jar' -UseBasicParsing ;
