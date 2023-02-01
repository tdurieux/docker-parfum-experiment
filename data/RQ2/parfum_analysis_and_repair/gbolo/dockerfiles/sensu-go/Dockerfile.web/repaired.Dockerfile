# github.com/gbolo/dockerfiles/lego/Dockerfile

#
#  BUILD CONTAINER -------------------------------------------------------------
#

FROM gbolo/builder:alpine

# Arguments
ARG   sensu_web_version=v1.0.1

# Building
RUN set -xe; \
      apk add --no-cache yarn && \
      git clone -b master --single-branch https://github.com/sensu/web.git && \
      cd web; \
      if [ "${sensu_web_version}" != "master" ]; then git checkout ${sensu_web_version}; fi && \
      yarn install && yarn cache clean;


WORKDIR /web
ENTRYPOINT  ["yarn", "node", "scripts", "serv"]
