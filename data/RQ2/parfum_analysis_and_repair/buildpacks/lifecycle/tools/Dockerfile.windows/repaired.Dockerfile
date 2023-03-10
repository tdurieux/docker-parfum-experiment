ARG image_tag
FROM ${image_tag} as builder

SHELL ["cmd.exe", "/c"]

RUN mkdir c:\tools\bin && \
    \
    git clone --branch=v20.10.5 --depth=1 https://github.com/docker/cli c:\gopath\src\github.com\docker\cli && \
    go get github.com/docker/cli/cmd/docker && \
    go build -o c:\tools\bin\docker.exe github.com/docker/cli/cmd/docker && \
    \
    git clone --branch=v0.3.6 --depth=1 https://github.com/kyoh86/richgo c:\gopath\src\github.com\kyoh86\richgo && \
    go get github.com/kyoh86/richgo && \
    go build -o c:\tools\bin\richgo.exe github.com/kyoh86/richgo && \
    \
    curl.exe -o make-installer.exe -L "https://sourceforge.net/projects/gnuwin32/files/make/3.81/make-3.81.exe" && \
    make-installer.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /DIR=C:\tools && \
    del make-installer.exe && \
    \
    curl.exe -o c:\tools\bin\jq.exe -L "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe" && \
    \
    setx /M PATH "%PATH%;c:\tools\bin" && \
    \
    mklink C:\git\usr\bin\bash.exe sh.exe && \
    \
    git config --global core.autocrlf false && \
    git config --global core.eol lf && \
    git config --global core.symlinks true && \
    \
    rmdir /q /s c:\gopath\src


# For reusing dependencies `-v gopathcache:c:/gopath`
ENV GOCMD=richgo
ENV GOPATH=c:\\gopath
ENV GOBIN=c:\\gopath\\bin
VOLUME ["c:/gopath"]

WORKDIR /lifecycle

# Copy git directory for consistent filesystem duplication of source (docker build, cp, volumes are inconsistent with symlinks/hardlinks on Windows)
COPY . /lifecycle/.git

RUN git reset --hard HEAD