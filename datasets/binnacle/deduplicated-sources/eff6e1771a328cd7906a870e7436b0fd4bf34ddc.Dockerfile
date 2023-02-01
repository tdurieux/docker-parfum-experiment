# escape=`

ARG core=mcr.microsoft.com/windows/servercore:1809
ARG target=mcr.microsoft.com/powershell:windowsservercore-1809

FROM $core as download

ARG node_version=10.13.0
ARG yarn_version=1.13.0

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV GPG_VERSION 2.3.4

RUN Invoke-WebRequest $('https://files.gpg4win.org/gpg4win-vanilla-{0}.exe' -f $env:GPG_VERSION) -OutFile 'gpg4win.exe' -UseBasicParsing ; `
    Start-Process .\gpg4win.exe -ArgumentList '/S' -NoNewWindow -Wait

RUN @( `
    '94AE36675C464D64BAFA68DD7434390BDBE9B9C5', `
    'FD3A5288F042B6850C66B31F09FE44734EB7990E', `
    '71DCFD284A79C3B38668286BC97EC7A07EDE3FC1', `
    'DD8F2338BAE7501E3DD5AC78C273792F7D83545D', `
    'C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8', `
    'B9AE9905FFD7803F25714661B63B535A4C206CA9', `
    '77984A986EBC2AA786BC0F66B01FBB92821C587A', `
    '8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600', `
    '4ED778F539E3634C779C87C6D7062848A1AB005C', `
    'A48C2BEE680E841632CD4E44F07496B3EB3C1762', `
    'B9E2F5981AA6E0CD28160D9FF13993A75599653C' `
    ) | foreach { `
      gpg --keyserver ha.pool.sks-keyservers.net --recv-keys $_ ; `
    }

ENV NODE_VERSION=$node_version

RUN Invoke-WebRequest $('https://nodejs.org/dist/v{0}/SHASUMS256.txt.asc' -f $env:NODE_VERSION) -OutFile 'SHASUMS256.txt.asc' -UseBasicParsing ; `
    gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc

RUN Invoke-WebRequest $('https://nodejs.org/dist/v{0}/node-v{0}-win-x64.zip' -f $env:NODE_VERSION) -OutFile 'node.zip' -UseBasicParsing ; `
    $sum = $(cat SHASUMS256.txt.asc | sls $('  node-v{0}-win-x64.zip' -f $env:NODE_VERSION)) -Split ' ' ; `
    if ((Get-FileHash node.zip -Algorithm sha256).Hash -ne $sum[0]) { Write-Error 'SHA256 mismatch' } ; `
    Expand-Archive node.zip -DestinationPath C:\ ; `
    Rename-Item -Path $('C:\node-v{0}-win-x64' -f $env:NODE_VERSION) -NewName 'C:\nodejs'

ENV YARN_VERSION=$yarn_version

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; `
    Invoke-WebRequest $('https://yarnpkg.com/downloads/{0}/yarn-{0}.msi' -f $env:YARN_VERSION) -OutFile yarn.msi -UseBasicParsing ; `
    $sig = Get-AuthenticodeSignature yarn.msi ; `
    if ($sig.Status -ne 'Valid') { Write-Error 'Authenticode signature is not valid' } ; `
    Write-Output $sig.SignerCertificate.Thumbprint ; `
    if (@( `
      '7E253367F8A102A91D04829E37F3410F14B68A5F', `
      'AF764E1EA56C762617BDC757C8B0F3780A0CF5F9' `
      ) -notcontains $sig.SignerCertificate.Thumbprint) { Write-Error 'Unknown signer certificate' } ; `
    Start-Process msiexec.exe -ArgumentList '/i', 'yarn.msi', '/quiet', '/norestart' -NoNewWindow -Wait

ENV GIT_VERSION 2.20.1
ENV GIT_DOWNLOAD_URL https://github.com/git-for-windows/git/releases/download/v${GIT_VERSION}.windows.1/MinGit-${GIT_VERSION}-busybox-64-bit.zip
ENV GIT_SHA256 9817ab455d9cbd0b09d8664b4afbe4bbf78d18b556b3541d09238501a749486c

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; `
    Invoke-WebRequest -UseBasicParsing $env:GIT_DOWNLOAD_URL -OutFile git.zip; `
    if ((Get-FileHash git.zip -Algorithm sha256).Hash -ne $env:GIT_SHA256) {exit 1} ; `
    Expand-Archive git.zip -DestinationPath C:\git; `
    Remove-Item git.zip

FROM $target as baseimage

ENV NPM_CONFIG_LOGLEVEL info

COPY --from=download /nodejs /nodejs
COPY --from=download [ "/Program Files (x86)/yarn", "/yarn" ]
COPY --from=download /git /git

ARG SETX=/M
RUN setx %SETX% PATH "%PATH%;C:\nodejs;C:\yarn\bin;C:\git\cmd;C:\git\mingw64\bin;C:\git\usr\bin"

CMD [ "node.exe" ]

FROM baseimage

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Invoke-WebRequest -UseBasicParsing 'https://www.7-zip.org/a/7z1805-x64.exe' -OutFile 7z.exe; `
    Start-Process -FilePath 'C:\\7z.exe' -ArgumentList '/S', '/D=C:\\7zip0' -NoNewWindow -Wait; `
    Invoke-WebRequest -UseBasicParsing 'http://repo.msys2.org/distrib/x86_64/msys2-base-x86_64-20180531.tar.xz' -OutFile msys2.tar.xz; `
    Start-Process -FilePath 'C:\\7zip\\7z' -ArgumentList 'e', 'msys2.tar.xz' -Wait; `
    Start-Process -FilePath 'C:\\7zip\\7z' -ArgumentList 'x', 'msys2.tar', '-oC:\\' -Wait; `
    Remove-Item msys2.tar.xz; `
    Remove-Item msys2.tar; `
    Remove-Item 7z.exe; `
    Remove-Item -Recurse 7zip; `
    [Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\msys64\usr\bin', [System.EnvironmentVariableTarget]::Machine); `
    [Environment]::SetEnvironmentVariable('BAZEL_SH', 'C:\msys64\usr\bin\bash.exe', [System.EnvironmentVariableTarget]::Machine)

# Install VS Build Tools
RUN Invoke-WebRequest -UseBasicParsing https://download.visualstudio.microsoft.com/download/pr/df649173-11e9-4af2-8eb7-0eb02ba8958a/cadb5bdac41e55bb8f6a6b7c45273370/vs_buildtools.exe -OutFile vs_BuildTools.exe; `
    # Installer won't detect DOTNET_SKIP_FIRST_TIME_EXPERIENCE if ENV is used, must use setx /M
    setx /M DOTNET_SKIP_FIRST_TIME_EXPERIENCE 1; `
    Start-Process vs_BuildTools.exe `
        -ArgumentList `
            '--add', 'Microsoft.VisualStudio.Workload.VCTools', `
            '--add', 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64', `
            '--add', 'Microsoft.Component.VC.Runtime.UCRTSDK', `
            '--add', 'Microsoft.VisualStudio.Component.Windows10SDK.17763', `
            '--quiet', '--norestart', '--nocache' `
        -NoNewWindow -Wait; `
    Remove-Item -Force vs_buildtools.exe; `
    Remove-Item -Force -Recurse \"${Env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\"; `
    Remove-Item -Force -Recurse ${Env:TEMP}\*; `
    Remove-Item -Force -Recurse \"${Env:ProgramData}\Package Cache\"; `
    [Environment]::SetEnvironmentVariable('BAZEL_VC', \"${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\BuildTools\VC\", [System.EnvironmentVariableTarget]::Machine)

# Install Python
RUN Invoke-WebRequest -UseBasicParsing https://www.python.org/ftp/python/3.5.1/python-3.5.1.exe -OutFile python-3.5.1.exe; `
    Start-Process python-3.5.1.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait; `
    Remove-Item -Force python-3.5.1.exe

CMD ["cmd.exe"]
