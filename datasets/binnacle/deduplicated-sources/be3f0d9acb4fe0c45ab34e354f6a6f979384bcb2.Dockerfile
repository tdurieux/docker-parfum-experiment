FROM microsoft/nanoserver:1803
LABEL maintainer "Lucas Lorentz <lucaslorentzlara@hotmail.com>"

EXPOSE 80 443 2015

COPY artifacts/binaries/windows/amd64/caddy.exe "C:\\caddy.exe"

ENTRYPOINT ["C:\\caddy.exe"]