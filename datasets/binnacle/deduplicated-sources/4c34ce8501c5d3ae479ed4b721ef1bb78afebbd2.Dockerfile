# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Install .NET Fx 3.5
RUN powershell -Command `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        Invoke-WebRequest `
            -UseBasicParsing `
            -Uri "https://dotnetbinaries.blob.core.windows.net/dockerassets/microsoft-windows-netfx3-1809.zip" `
            -OutFile microsoft-windows-netfx3.zip; `
        Expand-Archive microsoft-windows-netfx3.zip; `
        Remove-Item -Force microsoft-windows-netfx3.zip; `
        Add-WindowsPackage -Online -PackagePath .\microsoft-windows-netfx3\microsoft-windows-netfx3-ondemand-package~31bf3856ad364e35~amd64~~.cab; `
        Remove-Item -Force -Recurse microsoft-windows-netfx3

# This fails. Removing until we know if a similar patch is needed...
# Apply latest patch
#RUN powershell -Command `
#        $ErrorActionPreference = 'Stop'; `
#        $ProgressPreference = 'SilentlyContinue'; `
#        Invoke-WebRequest `
#            -UseBasicParsing `
#            -Uri "http://download.windowsupdate.com/d/msdownload/update/software/secu/2018/10/windows10.0-kb4462919-x64_654232d26f359fcff9b2832e3b02133e066cb928.msu" `
#            -OutFile patch.msu; `
#        New-Item -Type Directory patch; `
#       Start-Process expand -ArgumentList 'patch.msu', 'patch', '-F:*' -NoNewWindow -Wait; `
#       Remove-Item -Force patch.msu; `
#       Add-WindowsPackage -Online -PackagePath C:\patch\Windows10.0-KB4462919-x64.cab; `
#       Remove-Item -Force -Recurse \patch

# ngen .NET 3.5 Fx
ENV COMPLUS_NGenProtectedProcess_FeatureEnabled 0
RUN \Windows\Microsoft.NET\Framework64\v2.0.50727\ngen update & `
    \Windows\Microsoft.NET\Framework\v2.0.50727\ngen update