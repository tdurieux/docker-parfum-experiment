ARG BASE_IMAGE
FROM ${BASE_IMAGE} AS build_stage
ARG BUILD_DATE
ARG VERSION
ARG NAME
ARG TAGNAME
ARG IS_STATIC=$IS_STATIC

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$VERSION \
      org.label-schema.is_static=$IS_STATIC

ENV TZ="Asia/Seoul"  \
    TERM="xterm-256color" \
    USERID=24988 \
    APP_DIR="prep_peer" \
    APP_VERSION=${NAME}_${TAGNAME} \
    GOPATH=/go \
    GOROOT=/usr/local/go \
    PATH=$GOROOT/bin:$GOPATH:/src/:$PATH \
    IS_LOCAL=true \
    INSTALL_PACKAGE="make gcc libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev \
    wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev automake \
    libtool unzip jq netcat moreutils libsecp256k1-dev \
    git gnupg2 socat ntp  logrotate ntpdate vim procps \
    iproute2 lsof jq pigz axel monit gawk libcurl4-openssl-dev" \
    ERLANG_PACKAGE="erlang-base erlang-asn1 erlang-crypto \
    erlang-eldap erlang-ftp erlang-inets \
    erlang-mnesia erlang-os-mon erlang-parsetools \
    erlang-public-key  erlang-runtime-tools erlang-snmp \
    erlang-ssl  erlang-syntax-tools erlang-tftp \
    erlang-tools erlang-xmerl"\
    DELETE_PACKAGE="gcc gcc-6 g++* g++-6* make git automake"\
    S6_KILL_FINISH_MAXTIME=10000 \
    PYTHONUNBUFFERED=1

COPY src /src
COPY src/pip.conf /etc/
COPY conf $APP_DIR/conf
RUN echo "IS_STATIC = $IS_STATIC"; \
    echo "Starting static build" ; \
    /usr/local/bin/python -m pip install --upgrade pip ; \
    /src/static_builder.py -o /${APP_DIR}/whl ; \
    WHL_LIST=`find /$APP_DIR/ -name "*.whl"` && \
    ICON_RC=`find /$APP_DIR/ -name "icon_rc"` && \
    if [ "x${ICON_RC}" != "x" ]; then \
        cp $ICON_RC /usr/local/bin  || exit 1;\
    fi; \
    if [ ! -f "/usr/local/bin/icon_rc" ]; then \
        echo "icon_rc not found"; \
        exit 127;\
    fi; \
    for FILE in $WHL_LIST; do \
    
        pip3 install --no-cache-dir $FILE; \
        if [ $? != 0 ]; \
            then exit 127; \
        fi; \
       done \
    ;
#FROM python:3.7.3-slim-stretch
#COPY --from=build_stage /usr/bin /usr/bin
#COPY --from=build_stage /lib /lib
#COPY --from=build_stage /usr/lib /usr/lib
#COPY --from=build_stage /usr/sbin /usr/sbin
#COPY --from=build_stage /usr/local/bin /usr/local/bin
#COPY --from=build_stage /usr/local/lib/python3.7 /usr/local/lib/python3.7
#COPY --from=build_stage /prep_peer /prep_peer
#COPY --from=build_stage /src /src

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.1/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /
RUN cp /src/graceful_shutdown.sh /etc/cont-finish.d/

EXPOSE 9000
EXPOSE 7100
HEALTHCHECK --retries=4 --interval=30s --timeout=20s --start-period=60s \
    CMD python3 /src/healthcheck.py
RUN echo 'export PS1=" \[\e[00;32m\]${APP_VERSION}\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[00;31m\]\H :\\$\[\e[0m\] "' >> /root/.bashrc
ENTRYPOINT [ "/src/entrypoint.sh" ]

