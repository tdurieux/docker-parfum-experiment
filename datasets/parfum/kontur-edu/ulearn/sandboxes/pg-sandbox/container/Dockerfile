FROM postgres:alpine

#---- postgres
    ENV \
        PGDATA=/var/lib/pgsql/data/ \
        DB_DUMP_URL='https://edu.postgrespro.ru/demo-medium.zip' \
        DUMP_DIR=demo-air-db \
        POSTGRES_PASSWORD='postgres' \
        DOCKER_ENTRYPOINT=/usr/local/bin/docker-entrypoint.sh

    #COPY docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d/
    COPY postgres.conf.d/* /etc/postgres/conf.d/

    RUN set -euo pipefail \
        && apk add --no-cache --upgrade grep \
        && echo '1) Run postgres DB internally for init cluster:' \
            && bash -c "$DOCKER_ENTRYPOINT postgres --autovacuum=off &" \
            && sleep 10 \
        && echo '2) Configure postgres: use conf.d directory:' \
            && sed -i "s@#include_dir = '...'@include_dir = '/etc/postgres/conf.d/'@" "$PGDATA/postgresql.conf" \
        && echo '3) Populate DB data: Restore DB backup:' \
            && wget -O $DUMP_DIR.zip "$DB_DUMP_URL" \
            && unzip $DUMP_DIR.zip -d "$DUMP_DIR" \
            && find demo-air-db -type f -name *.sql -print0 | xargs -I {} psql -U postgres -nxq -f {} \
            && rm -rf $DUMP_DIR && rm $DUMP_DIR.zip \
        && echo '4) Vacuum full and analyze (no reindex need then):' \
            && time vacuumdb -U postgres --full --all --analyze --freeze \
        && echo '5) Stop postgres:' \
            && su-exec postgres pg_ctl -D "$PGDATA" -m fast -w stop \
            && sleep 10 \
        && echo '6) Cleanup pg_xlog required to do not include it in image:' \
            && su-exec postgres pg_resetwal -o \
                $( LANG=C pg_controldata $PGDATA | grep -oP '(?<=NextOID:\s{10})\d+' ) -x \
                $( LANG=C pg_controldata $PGDATA | grep -oP '(?<=NextXID:\s{10}0[/:])\d+' ) -f $PGDATA

#---- net5
    ENV \
        ASPNETCORE_URLS= \
        DOTNET_RUNNING_IN_CONTAINER=true \
        DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
        DOTNET_PACKAGES_DIR=/dotnet-packages \
        DOTNET_USE_POLLING_FILE_WATCHER=true \
        NUGET_XMLDOC_MODE=skip \
        DOTNET_VERSION=5.0.2 \
        ASPNET_VERSION=5.0.2 \
        DOTNET_SDK_VERSION=5.0.102

    COPY $DOTNET_PACKAGES_DIR/* $DOTNET_PACKAGES_DIR/
    WORKDIR $DOTNET_PACKAGES_DIR

    RUN  set -euo pipefail \
        && echo '1) Install dotnet dependencies' \
            && apk add --no-cache \
                ca-certificates \
                \
                # .NET Core dependencies
                krb5-libs \
                libgcc \
                libintl \
                libssl1.1 \
                libstdc++ \
                zlib \
                icu-libs \
        && echo '2) Install .NET:'\
            && wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-musl-x64.tar.gz \
            && dotnet_sha512='84e69846188689cf5ee1eddce77c6cf92a7becddac9cdd9b985a490446d5acbd5d59e3703e8da4241895c1907b85bac852735c756098774e3b890c1944cda64f' \
            && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
            && mkdir -p /usr/share/dotnet \
            && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz \
            && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
            && rm dotnet.tar.gz \
        && echo '3) Install Asp.NET Core:'\
            && wget -O aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$ASPNET_VERSION/aspnetcore-runtime-$ASPNET_VERSION-linux-musl-x64.tar.gz \
            && aspnetcore_sha512='d9582bee1dc513288d386ee52bdeb9ed4d5d191d6843b68773f7979ea0d0527c35599722d700a33ce9d59752b44666b17ab7bb36da169c180965252a2742174c' \
            && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
            && tar -ozxf aspnetcore.tar.gz -C /usr/share/dotnet ./shared/Microsoft.AspNetCore.App \
            && rm aspnetcore.tar.gz \
        && echo '4) Install .NET SDK:'\
            && wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-musl-x64.tar.gz \
            && dotnet_sha512='91ac9ea608b38402b2424d7754a823fade38261904a0fbb087f982b324aacf322c3500b520507f21b4aaac40eb059d8ef6d1656fd4f161d5afde2950210e86e8' \
            && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
            && mkdir -p /usr/share/dotnet \
            && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./packs ./sdk ./templates ./LICENSE.txt ./ThirdPartyNotices.txt \
            && rm dotnet.tar.gz \
        && echo '5) Install nuget packages:'\
            && dotnet build packages.csproj \
            && rm -rf $DOTNET_PACKAGES_DIR

WORKDIR /
RUN mkdir /app
WORKDIR app