FROM ubuntu
LABEL "Maintainer"="Scott Hansen <firecat4153@gmail.com>"

ARG uid=1000
ARG gid=100
ARG DEBIAN_FRONTEND=noninteractive
ENV XDG_CONFIG_HOME=/config

RUN apt-get update && \
    apt-get install -qy curl software-properties-common && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb http://download.mono-project.com/repo/ubuntu stable-bionic main" | \
        tee /etc/apt/sources.list.d/mono.list && \
    apt-get update && \
    apt-get install -qy mono-devel libcurl4-openssl-dev ca-certificates-mono && \
    # Change `users` gid to match the passed in $gid
    [ $(getent group users | cut -d: -f3) == $gid ] || \
            sed -i "s/users:x:[0-9]\+:/users:x:$gid:/" /etc/group && \
    useradd --no-create-home -g users -u $uid jackett && \
    mkdir -p /opt/Jackett /config && \
    tag=$(curl -sX GET "https://api.github.com/repos/Jackett/Jackett/releases/latest" \
        | awk '/tag_name/{print $4;exit}' FS='[""]') && \
    curl -o \
        /tmp/jacket.tar.gz -L \
        https://github.com/Jackett/Jackett/releases/download/$tag/Jackett.Binaries.Mono.tar.gz && \
    tar xf /tmp/jacket.tar.gz -C /opt/Jackett --strip-components=1 && \
    chown -R jackett:users /opt/Jackett /config && \
    apt-get autoremove -qy curl gcc software-properties-common && \
    rm -rf /var/lib/apt/lists

EXPOSE 9117
USER jackett
VOLUME ["/config", "/data/"]
WORKDIR /config

CMD ["mono", "/opt/Jackett/JackettConsole.exe", "--NoUpdates"]
