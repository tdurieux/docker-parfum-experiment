FROM mcr.microsoft.com/powershell:nanoserver-1809 AS base

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install JRE
RUN [Net.ServicePointManager]::SecurityProtocol = 'tls12, tls11, tls' ; \
    Invoke-WebRequest https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u192-b12/OpenJDK8U-jre_x64_windows_hotspot_8u192b12.zip -OutFile jre.zip; \
    Expand-Archive jre.zip -DestinationPath $Env:ProgramFiles\Java ; \
    Get-ChildItem $Env:ProgramFiles\Java | Rename-Item -NewName "OpenJDK" ; \
    Remove-Item -Force jre.zip

# Install tools from JDK
RUN [Net.ServicePointManager]::SecurityProtocol = 'tls12, tls11, tls' ; \
    Invoke-WebRequest https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u192-b12/OpenJDK8U-jdk_x64_windows_hotspot_8u192b12.zip -OutFile jdk.zip; \
    Expand-Archive jdk.zip -DestinationPath $Env:Temp\JDK ; \
    Get-ChildItem $Env:Temp\JDK | Rename-Item -NewName "OpenJDK" ; \
    ('jar.exe', 'jcmd.exe', 'jconsole.exe', 'jmap.exe', 'jstack.exe', 'jps.exe') | foreach { \
         Copy-Item $Env:Temp\JDK\OpenJDK\bin\$_ $Env:ProgramFiles\Java\OpenJDK\bin\ \
    } ; \
    Remove-Item -Force -Recurse $Env:Temp\JDK ; \
    Remove-Item -Force jdk.zip

# Prepare build agent distribution
COPY buildAgent.zip /
RUN Expand-Archive buildAgent.zip -DestinationPath C:/BuildAgent ; \
    Move-Item -Path C:/BuildAgent/conf -Destination C:/BuildAgent/conf_dist
COPY run-agent.ps1 /BuildAgent/run-agent.ps1

# Workaround for https://github.com/PowerShell/PowerShell-Docker/issues/164
FROM mcr.microsoft.com/windows/nanoserver:1809

ENV ProgramFiles="C:\Program Files" \
    # set a fixed location for the Module analysis cache
    LOCALAPPDATA="C:\Users\ContainerAdministrator\AppData\Local" \
    PSModuleAnalysisCachePath="$LOCALAPPDATA\Microsoft\Windows\PowerShell\docker\ModuleAnalysisCache" \
    # Persist %PSCORE% ENV variable for user convenience
    PSCORE="$ProgramFiles\PowerShell\pwsh.exe"

COPY --from=base ["C:/Program Files/PowerShell", "C:/Program Files/PowerShell"]

# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
RUN setx /M PATH "%PATH%;%ProgramFiles%\PowerShell"
USER ContainerUser

# intialize powershell module cache
RUN pwsh -NoLogo -NoProfile -Command " \
    $stopTime = (get-date).AddMinutes(15); \
    $ErrorActionPreference = 'Stop' ; \
    $ProgressPreference = 'SilentlyContinue' ; \
    while(!(Test-Path -Path $env:PSModuleAnalysisCachePath)) {  \
        Write-Host "'Waiting for $env:PSModuleAnalysisCachePath'" ; \
        if((get-date) -gt $stopTime) { throw 'timout expired'} \
        Start-Sleep -Seconds 6 ; \
    }"

COPY --from=base ["C:/Program Files/Java/OpenJDK", "C:/Program Files/Java/OpenJDK"]

ENV JRE_HOME="C:\Program Files\Java\OpenJDK" \
    CONFIG_FILE="C:\BuildAgent\conf\buildAgent.properties"

EXPOSE 9090

VOLUME C:/BuildAgent/conf

COPY --from=base /BuildAgent /BuildAgent

CMD pwsh ./BuildAgent/run-agent.ps1