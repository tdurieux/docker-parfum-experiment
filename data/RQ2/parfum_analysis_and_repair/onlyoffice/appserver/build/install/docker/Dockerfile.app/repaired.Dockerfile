### STAGE 1: Base image ######
ARG SRC_PATH=/app/onlyoffice/src
ARG BUILD_PATH=/var/www
ARG REPO_SDK=mcr.microsoft.com/dotnet/sdk
ARG REPO_SDK_TAG=6.0
ARG REPO_RUN=mcr.microsoft.com/dotnet/aspnet
ARG REPO_RUN_TAG=6.0

FROM $REPO_SDK:$REPO_SDK_TAG AS base
ARG RELEASE_DATE="2016-06-21"
ARG DEBIAN_FRONTEND=noninteractive
ARG PRODUCT_VERSION=0.0.0
ARG BUILD_NUMBER=0
ARG GIT_BRANCH=master
ARG SRC_PATH
ARG BUILD_PATH
ARG BUILD_ARGS=build
ARG DEPLOY_ARGS=deploy
ARG DEBUG_INFO=true

LABEL onlyoffice.appserver.release-date="${RELEASE_DATE}" \
      maintainer="Ascensio System SIA <support@onlyoffice.com>"

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN echo "nameserver 8.8.8.8" | tee /etc/resolv.conf > /dev/null && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get install --no-install-recommends -yq sudo locales && \
    addgroup --system --gid 107 onlyoffice && \
    adduser -uid 104 --quiet --home /var/www/onlyoffice --system --gid 107 onlyoffice && \
    locale-gen en_US.UTF-8 && \
    apt-get -y update && \
    apt-get install --no-install-recommends -yq git apt-utils npm && \
    npm install --global yarn && \
    curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
    apt-get install --no-install-recommends -y nodejs && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

RUN echo ${GIT_BRANCH}  && \
    git clone --recurse-submodules -b ${GIT_BRANCH} https://github.com/ONLYOFFICE/AppServer.git ${SRC_PATH}

RUN cd ${SRC_PATH} && \
    mkdir -p /app/onlyoffice/config/ && cp -rf config/* /app/onlyoffice/config/ && \
    mkdir -p /etc/nginx/conf.d && cp -f config/nginx/onlyoffice*.conf /etc/nginx/conf.d/ && \
    mkdir -p /etc/nginx/includes/ && cp -f config/nginx/includes/onlyoffice*.conf /etc/nginx/includes/ && \
    sed -i "s/\"number\".*,/\"number\": \"${PRODUCT_VERSION}.${BUILD_NUMBER}\",/g" /app/onlyoffice/config/appsettings.json && \
    sed -e 's/#//' -i /etc/nginx/conf.d/onlyoffice.conf && \
    cd ${SRC_PATH}/build/install/common/ && \
    bash build-frontend.sh -sp "${SRC_PATH}" -ba "${BUILD_ARGS}" -da "${DEPLOY_ARGS}" -di "${DEBUG_INFO}" && \
    bash build-backend.sh -sp "${SRC_PATH}"  && \
    bash publish-backend.sh -sp "${SRC_PATH}" -bp "${BUILD_PATH}"  && \
    cp -rf ${SRC_PATH}/products/ASC.Files/Server/DocStore ${BUILD_PATH}/products/ASC.Files/server/ && \
    rm -rf ${SRC_PATH}/common/* && \
    rm -rf ${SRC_PATH}/web/ASC.Web.Core/* && \
    rm -rf ${SRC_PATH}/web/ASC.Web.Studio/* && \
    rm -rf ${SRC_PATH}/products/ASC.Calendar/Server/* && \
    rm -rf ${SRC_PATH}/products/ASC.CRM/Server/* && \
    rm -rf ${SRC_PATH}/products/ASC.Files/Server/* && \
    rm -rf ${SRC_PATH}/products/ASC.Files/Service/* && \
    rm -rf ${SRC_PATH}/products/ASC.Mail/Server/* && \
    rm -rf ${SRC_PATH}/products/ASC.People/Server/* && \
    rm -rf ${SRC_PATH}/products/ASC.Projects/Server/*

COPY config/mysql/conf.d/mysql.cnf /etc/mysql/conf.d/mysql.cnf

RUN rm -rf /var/lib/apt/lists/*

### STAGE 2: Build ###
FROM $REPO_RUN:$REPO_RUN_TAG as builder
ARG BUILD_PATH
ENV BUILD_PATH=${BUILD_PATH}

COPY --from=base /app/onlyoffice/config/*.json /app/onlyoffice/config/
COPY --from=base /app/onlyoffice/config/*.config /app/onlyoffice/config/

# add defualt user and group for no-root run
RUN mkdir -p /var/log/onlyoffice && \
    mkdir -p /app/onlyoffice/data && \
    addgroup --system --gid 107 onlyoffice && \
    adduser -uid 104 --quiet --home /var/www/onlyoffice --system --gid 107 onlyoffice && \
    chown onlyoffice:onlyoffice /app/onlyoffice -R && \
    chown onlyoffice:onlyoffice /var/log -R  && \
    chown onlyoffice:onlyoffice /var/www -R
RUN echo "nameserver 8.8.8.8" | tee /etc/resolv.conf > /dev/null && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -yq sudo nano curl vim && \
    curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    apt-get install --no-install-recommends -yq libgdiplus && rm -rf /var/lib/apt/lists/*;

#USER onlyoffice
EXPOSE 5050

ENTRYPOINT ["./docker-entrypoint.sh"]

### STAGE 3: Run ###

## Nginx image ##
FROM nginx AS web
ARG SRC_PATH
ARG BUILD_PATH
ARG COUNT_WORKER_CONNECTIONS=1024
ENV DNS_NAMESERVER=127.0.0.11 \
    COUNT_WORKER_CONNECTIONS=$COUNT_WORKER_CONNECTIONS \
    MAP_HASH_BUCKET_SIZE=""

RUN echo "nameserver 8.8.8.8" | tee /etc/resolv.conf > /dev/null && \ 
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -yq vim && \
    # Remove default nginx website
    rm -rf /usr/share/nginx/html/* && rm -rf /var/lib/apt/lists/*;

# copy static services files and config values
COPY --from=base /etc/nginx/conf.d /etc/nginx/conf.d
COPY --from=base /etc/nginx/includes /etc/nginx/includes
COPY --from=base ${SRC_PATH}/build/deploy/products ${BUILD_PATH}/products
COPY --from=base ${SRC_PATH}/build/deploy/public ${BUILD_PATH}/public
COPY --from=base ${SRC_PATH}/build/deploy/studio ${BUILD_PATH}/studio
COPY /config/nginx/templates/upstream.conf.template /etc/nginx/templates/upstream.conf.template
COPY /config/nginx/templates/nginx.conf.template /etc/nginx/nginx.conf.template
COPY prepare-nginx-proxy.sh /docker-entrypoint.d/prepare-nginx-proxy.sh

# add defualt user and group for no-root run
RUN chown nginx:nginx /etc/nginx/* -R && \
    chown nginx:nginx /docker-entrypoint.d/* && \
    # changes for upstream configure
    sed -i 's/localhost:5010/$service_api_system/' /etc/nginx/conf.d/onlyoffice.conf && \
    sed -i 's/localhost:5012/$service_backup/' /etc/nginx/conf.d/onlyoffice.conf && \
    sed -i 's/localhost:5021/$service_crm/' /etc/nginx/conf.d/onlyoffice.conf && \
    sed -i 's/localhost:5007/$service_files/' /etc/nginx/conf.d/onlyoffice.conf && \
    sed -i 's/localhost:5004/$service_people_server/' /etc/nginx/conf.d/onlyoffice.conf && \
    sed -i 's/localhost:5020/$service_projects_server/' /etc/nginx/conf.d/onlyoffice.conf && \
    sed -i 's/localhost:5000/$service_api/' /etc/nginx/conf.d/onlyoffice.conf && \
    sed -i 's/localhost:5003/$service_studio/' /etc/nginx/conf.d/onlyoffice.conf && \
    sed -i 's/localhost:5023/$service_calendar/' /etc/nginx/conf.d/onlyoffice.conf && \
    sed -i 's/localhost:9899/$service_socket/' /etc/nginx/conf.d/onlyoffice.conf && \
    sed -i 's/localhost:5022/$service_mail/' /etc/nginx/conf.d/onlyoffice.conf && \
    sed -i 's/localhost:9999/$service_urlshortener/' /etc/nginx/conf.d/onlyoffice.conf && \
    sed -i 's/172.*/$document_server;/' /etc/nginx/conf.d/onlyoffice.conf

## ASC.ApiSystem ##
FROM builder AS api_system
WORKDIR ${BUILD_PATH}/services/apisystem/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.ApiSystem/service .

CMD ["ASC.ApiSystem.dll", "ASC.ApiSystem"]

## ASC.Data.Backup ##
FROM builder AS backup
WORKDIR ${BUILD_PATH}/services/backup/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.Data.Backup/service .

CMD ["ASC.Data.Backup.dll", "ASC.Data.Backup", "core:products:folder=/var/www/products/", "core:products:subfolder=server"]

## ASC.Data.Storage.Encryption ##
FROM builder AS data_storage_encryption
WORKDIR ${BUILD_PATH}/services/storage.encryption/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.Data.Storage.Encryption/service/ .

CMD ["ASC.Data.Storage.Encryption.dll", "ASC.Data.Storage.Encryption"]

## ASC.Files ##
FROM builder AS files
WORKDIR ${BUILD_PATH}/products/ASC.Files/server/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/products/ASC.Files/server/ .

CMD ["ASC.Files.dll", "ASC.Files"]

## ASC.Files.Service ##
FROM builder AS files_services
WORKDIR ${BUILD_PATH}/products/ASC.Files/service/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.Files.Service/service/ .

CMD ["ASC.Files.Service.dll", "ASC.Files.Service", "core:products:folder=/var/www/products/", "core:products:subfolder=server", "disable_elastic=true"]

## ASC.Data.Storage.Migration ##
FROM builder AS data_storage_migration
WORKDIR ${BUILD_PATH}/services/storage.migration/service/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.Data.Storage.Migration/service/ .

CMD ["ASC.Data.Storage.Migration.dll", "ASC.Data.Storage.Migration"]

## ASC.Notify ##
FROM builder AS notify
WORKDIR ${BUILD_PATH}/services/notify/service

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.Notify/service/ .

CMD ["ASC.Notify.dll", "ASC.Notify", "core:products:folder=/var/www/products/", "core:products:subfolder=server"]

## ASC.People ##
FROM builder AS people_server
WORKDIR ${BUILD_PATH}/products/ASC.People/server/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/products/ASC.People/server/ .

CMD ["ASC.People.dll", "ASC.People"]

## ASC.Socket.IO.Svc ##
FROM builder AS socket
WORKDIR ${BUILD_PATH}/services/socket.io.svc/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.Socket.IO.Svc/service/ .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.Socket.IO/service/  ${BUILD_PATH}/ASC.Socket.IO/

CMD ["ASC.Socket.IO.Svc.dll", "ASC.Socket.IO.Svc"]

## ASC.Studio.Notify ##
FROM builder AS studio_notify
WORKDIR ${BUILD_PATH}/services/studio.notify/service/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.Studio.Notify/service/ .

CMD ["ASC.Studio.Notify.dll", "ASC.Studio.Notify", "core:products:folder=/var/www/products/", "core:products:subfolder=server"]

## ASC.TelegramService ##
FROM builder AS telegram_service
WORKDIR ${BUILD_PATH}/services/telegram/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.TelegramService/service/ .

CMD ["ASC.TelegramService.dll", "ASC.TelegramService"]

## ASC.Thumbnails.Svc ##
FROM builder AS thumbnails
WORKDIR ${BUILD_PATH}/services/thumb/service/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.Thumbnails.Svc/service/ .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.Thumbnails/service/ ${BUILD_PATH}/services/thumb/client

CMD ["ASC.Thumbnails.Svc.dll", "ASC.Thumbnails.Svc"]

## ASC.UrlShortener.Svc ##
FROM builder AS urlshortener
WORKDIR  ${BUILD_PATH}/services/urlshortener/service/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice  ${BUILD_PATH}/services/ASC.UrlShortener.Svc/service/ .
COPY --from=base --chown=onlyoffice:onlyoffice  ${BUILD_PATH}/services/ASC.UrlShortener/service/ ${BUILD_PATH}/services/urlshortener/client

CMD ["ASC.UrlShortener.Svc.dll", "ASC.UrlShortener.Svc"]

## ASC.Web.Api ##
FROM builder AS api
WORKDIR ${BUILD_PATH}/studio/api/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.Web.Api/service/ .

CMD ["ASC.Web.Api.dll", "ASC.Web.Api"]

## ASC.Web.Studio ##
FROM builder AS studio
WORKDIR ${BUILD_PATH}/studio/server/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.Web.Studio/service/ .

CMD ["ASC.Web.Studio.dll", "ASC.Web.Studio"]

## ASC.SsoAuth ##
FROM builder AS ssoauth
WORKDIR ${BUILD_PATH}/services/ASC.SsoAuth.Svc/

COPY --chown=onlyoffice:onlyoffice docker-entrypoint.sh .
COPY --from=base --chown=onlyoffice:onlyoffice ${BUILD_PATH}/services/ASC.SsoAuth.Svc/service/ .
COPY --from=base --chown=onlyoffice:onlyoffice  ${BUILD_PATH}/services/ASC.SsoAuth/service/ ${BUILD_PATH}/ASC.SsoAuth/

CMD ["ASC.SsoAuth.Svc.dll", "ASC.SsoAuth.Svc"]

## image for k8s bin-share ##
FROM busybox:latest AS bin_share
RUN mkdir -p /app/appserver/ASC.Files/server && \
    mkdir -p /app/appserver/ASC.People/server/ && \
    mkdir -p /app/appserver/ASC.CRM/server/ && \
    mkdir -p /app/appserver/ASC.Projects/server/ && \
    mkdir -p /app/appserver/ASC.Calendar/server/ && \
    mkdir -p /app/appserver/ASC.Mail/server/ && \
    addgroup --system --gid 107 onlyoffice && \
    adduser -u 104 onlyoffice --home /var/www/onlyoffice --system -G onlyoffice

COPY bin-share-docker-entrypoint.sh /app/docker-entrypoint.sh
COPY --from=base /var/www/products/ASC.Files/server/ /app/appserver/ASC.Files/server/
COPY --from=base /var/www/products/ASC.People/server/ /app/appserver/ASC.People/server/
# COPY --from=base /var/www/products/ASC.CRM/server/ /app/appserver/ASC.CRM/server/
# COPY --from=base /var/www/products/ASC.Projects/server/ /app/appserver/ASC.Projects/server/
# COPY --from=base /var/www/products/ASC.Calendar/server/ /app/appserver/ASC.Calendar/server/
# COPY --from=base /var/www/products/ASC.Mail/server/ /app/appserver/ASC.Mail/server/
ENTRYPOINT ["./app/docker-entrypoint.sh"]

## image for k8s wait-bin-share ##
FROM busybox:latest AS wait_bin_share
RUN mkdir /app

COPY wait-bin-share-docker-entrypoint.sh /app/docker-entrypoint.sh
ENTRYPOINT ["./app/docker-entrypoint.sh"]
