LABEL maintainer="Manuel Moos <z-man@users.sf.net>"

FROM base AS wine
# build dependencies
RUN apk add \
bash \
wine \
xvfb \
--no-cache

RUN adduser docker -D
RUN chmod 6755 /usr/bin/Xvfb
WORKDIR /home/docker
USER docker

COPY --chown=docker . /home/docker/