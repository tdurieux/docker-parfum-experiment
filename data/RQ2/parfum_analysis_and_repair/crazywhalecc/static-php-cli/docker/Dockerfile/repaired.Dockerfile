FROM alpine:latest

# define script basic information
# Version of this Dockerfile
ENV SCRIPT_VERSION=1.5.1
# Download address uses backup address

ARG USE_BACKUP_ADDRESS

# (if downloading slowly, consider set it to yes)
ENV USE_BACKUP="${USE_BACKUP_ADDRESS}"


# APK repositories mirror address, if u r not in China, consider set USE_BACKUP=yes to boost
ENV LINK_APK_REPO='mirrors.ustc.edu.cn'
ENV LINK_APK_REPO_BAK='dl-cdn.alpinelinux.org'

RUN if [ "${USE_BACKUP}" = "" ]; then \
        export USE_BACKUP="no" ; \
    fi

RUN if [ "${USE_BACKUP}" = "yes" ]; then \
        echo "Using backup original address..." ; \
    else \
        echo "Using mirror address..." && \
        sed -i 's/dl-cdn.alpinelinux.org/'${LINK_APK_REPO}'/g' /etc/apk/repositories ; \
    fi

# build requirements
RUN apk add --no-cache bash file wget cmake gcc g++ jq autoconf git libstdc++ linux-headers make m4 libgcc binutils ncurses dialog > /dev/null
# php zlib dependencies
RUN apk add --no-cache zlib-dev zlib-static > /dev/null
# php mbstring dependencies
RUN apk add --no-cache oniguruma-dev > /dev/null
# php openssl dependencies
RUN apk add --no-cache openssl-libs-static openssl-dev openssl > /dev/null
# php gd dependencies
RUN apk add --no-cache libpng-dev libpng-static > /dev/null
# curl c-ares dependencies
RUN apk add --no-cache c-ares-static c-ares-dev > /dev/null
# php event dependencies
RUN apk add --no-cache libevent libevent-dev libevent-static > /dev/null
# php sqlite3 dependencies
RUN apk add --no-cache sqlite sqlite-dev sqlite-libs sqlite-static > /dev/null
# php libzip dependencies
RUN apk add --no-cache bzip2-dev bzip2-static bzip2 > /dev/null
# php micro ffi dependencies
RUN apk add --no-cache libffi libffi-dev > /dev/null
# php gd event parent dependencies
RUN apk add --no-cache zstd-static > /dev/null
# php readline dependencies
RUN apk add --no-cache readline-static ncurses-static readline-dev > /dev/null

RUN mkdir /app

WORKDIR /app

COPY ./* /app/

RUN chmod +x /app/*.sh

RUN ./download.sh swoole ${USE_BACKUP} && \
    ./download.sh inotify ${USE_BACKUP} && \
    ./download.sh mongodb ${USE_BACKUP} && \
    ./download.sh event ${USE_BACKUP} && \
    ./download.sh redis ${USE_BACKUP} && \
    ./download.sh libxml2 ${USE_BACKUP} && \
    ./download.sh xz ${USE_BACKUP} && \
    ./download.sh curl ${USE_BACKUP} && \
    ./download.sh libzip ${USE_BACKUP} && \
    ./download.sh libiconv ${USE_BACKUP} && \
    ./download-git.sh dixyes/phpmicro phpmicro ${USE_BACKUP}

RUN ./compile-deps.sh
RUN echo -e "#!/usr/bin/env bash\n/app/compile-php.sh \$@" > /bin/build-php && chmod +x /bin/build-php
