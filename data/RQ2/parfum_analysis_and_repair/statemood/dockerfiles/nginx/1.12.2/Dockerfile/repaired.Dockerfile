# --------------------------------------------
# Created by Statemood, 2018.01.06
#            I.am.RuLin@gmail.com
#
# Project dockerfiles:
#    https://github.com/Statemood/dockerfiles
# --------------------------------------------

FROM statemood/alpine:3.7

COPY files  /

RUN apk update		&& \
    apk upgrade && \
    apk add --no-cache "nginx~=1.12.2" && \
    chmod 755 /run.sh

ENTRYPOINT ["/run.sh"]