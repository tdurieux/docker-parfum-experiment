# escape=`

ARG FROM_IMAGE=mcr.microsoft.com/windows/servercore:ltsc2019
FROM ${FROM_IMAGE}

# Reset the shell.
SHELL ["cmd", "/S", "/C"]

# Download and install Build Tools for Visual Studio 2017.
ADD https://aka.ms/vs/15/release/channel C:\TEMP\VisualStudio15.chman
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools_15.exe
RUN C:\TEMP\vs_buildtools_15.exe `
    --quiet --wait --norestart --nocache `
    --includeRecommended `
    --channelUri C:\TEMP\VisualStudio15.chman `
    --installChannelUri C:\TEMP\VisualStudio15.chman `
    --add Microsoft.VisualStudio.Workload.VCTools `
    --add Microsoft.VisualStudio.Workload.NativeDesktop `
    --add Microsoft.VisualStudio.Component.VC.ATLMFC `
    --add Microsoft.Component.MSBuild

# Download and install Build Tools for Visual Studio 2019.
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools_16.exe
RUN C:\TEMP\vs_buildtools_16.exe `
    --quiet --wait --norestart --nocache `
    --includeRecommended `
    --add Microsoft.VisualStudio.Component.VC.ATLMFC `
    --add Microsoft.VisualStudio.Workload.NativeDesktop `
    --add Microsoft.VisualStudio.Workload.VCTools `
    --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools `
    --add Microsoft.VisualStudio.Workload.NetCoreBuildTools `
    --add Microsoft.VisualStudio.Workload.WebBuildTools `
    --add Microsoft.VisualStudio.Component.VC.ATLMFC

# Install cmake, git, 7zip, python2 & python3.
RUN powershell.exe Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); `
    choco install cmake -y --installargs 'ADD_CMAKE_TO_PATH=System'; `
    choco install 7zip.install git python2 python3 -y; `
    setx /M PYTHON2 'C:\Python27\python.exe'; `
    refreshenv

# Install depot_tools, add to PATH.
RUN powershell.exe -ExecutionPolicy RemoteSigned `
    (new-object net.webclient).DownloadFile('https://storage.googleapis.com/chrome-infra/depot_tools.zip', 'C:/depot_tools.zip'); `
    Expand-Archive -Path 'C:/depot_tools.zip' -DestinationPath 'C:/depot_tools'; `
    del C:/depot_tools.zip; `
    setx /M PATH $('C:\depot_tools;' + $Env:PATH); `
    setx /M DEPOT_TOOLS_WIN_TOOLCHAIN 0;`
    setx /M vs2017_install 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools';

# Install Windows 10 SDKs 19041 and 17134 with all extra features (including the WindowsDesktopDebuggers)
ADD https://download.microsoft.com/download/1/c/3/1c3d5161-d9e9-4e4b-9b43-b70fe8be268c/windowssdk/winsdksetup.exe C:\TEMP\winsdk19041.exe
RUN C:\TEMP\winsdk19041.exe /Features + /Quiet /NoRestart /Log "C:\TEMP\winsdk19041.log"

ADD https://download.microsoft.com/download/5/A/0/5A08CEF4-3EC9-494A-9578-AB687E716C12/windowssdk/winsdksetup.exe C:\TEMP\winsdk17134.exe
RUN C:\TEMP\winsdk17134.exe /Features + /Quiet /NoRestart /Log "C:\TEMP\winsdk17134.log"

# Install cake
COPY build.ps1 C:/TEMP/cake/build.ps1
COPY tools/packages.config C:/TEMP/cake/tools/packages.config
RUN powershell.exe C:/TEMP/cake/build.ps1 -JustInstall

# Set up a special env var so build-docker.ps1 knows whether it is running
# inside the docker image or not.
RUN powershell.exe -ExecutionPolicy RemoteSigned `
    setx /M inside_shader_playground_docker_image 1;

ENTRYPOINT ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
