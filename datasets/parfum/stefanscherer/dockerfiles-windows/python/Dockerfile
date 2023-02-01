# escape=`
FROM python:3.6-windowsservercore AS python

FROM mcr.microsoft.com/windows/nanoserver:10.0.14393.2068

COPY --from=python /Python /Python

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV PYTHON_VERSION 3.6.1
ENV PYTHON_PIP_VERSION 9.0.1

RUN $env:PATH = 'C:\Python;C:\Python\Scripts;{0}' -f $env:PATH ; `
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' -Name Path -Value $env:PATH ; `
    mkdir $env:APPDATA\Python\Python36\site-packages ; `
    Invoke-WebRequest 'https://bootstrap.pypa.io/get-pip.py' -OutFile 'get-pip.py' -UseBasicParsing ; `
    $replace = ('import tempfile{0}import site{0}site.getusersitepackages()' -f [char][int]10) ; `
    Get-Content get-pip.py | Foreach-Object { $_ -replace 'import tempfile', $replace } | Out-File -Encoding Ascii getpip.py ; `
    $pipInstall = ('pip=={0}' -f $env:PYTHON_PIP_VERSION) ; `
    python getpip.py $pipInstall ; `
    Remove-Item get-pip.py ; `
    Remove-Item getpip.py

RUN pip install --no-cache-dir virtualenv

CMD [ "python.exe" ]
