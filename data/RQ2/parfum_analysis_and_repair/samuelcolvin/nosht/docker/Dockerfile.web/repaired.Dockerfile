# ===============================================
# js build stage
FROM python:2.7-alpine3.9 as js-build
RUN apk --no-cache add nodejs npm yarn make g++
WORKDIR /home/root

ADD ./js/package.json /home/root/package.json
ADD ./js/yarn.lock /home/root/yarn.lock
RUN echo "node: $(node -v), npm: $(npm -v), yarn: $(yarn -v)" \
 && yarn

ARG HEROKU_APP
RUN echo "build for heroku app: $HEROKU_APP"
ADD ./js/.env /home/root/.env
ADD ./deploy-settings-$HEROKU_APP/.env.production /home/root/.env.production
ADD ./js/src /home/root/src
ADD ./js/public /home/root/public
ADD ./deploy-settings-$HEROKU_APP/favicons/* /home/root/public/
ARG COMMIT
RUN REACT_APP_COMMIT=$COMMIT INLINE_RUNTIME_CHUNK=false yarn build

RUN echo '' >> build/index.html
RUN echo '<!-- nosht event platform, see https://github.com/samuelcolvin/nosht for more details -->' >> build/index.html
RUN echo "<!-- build: $COMMIT at $(date) -->" >> build/index.html
RUN rm build/service-worker.js
RUN find build/ -type f | xargs ls -lh

# ===============================================
# pre-built python build stage
FROM nosht-python-build as python-build

# ===============================================
# final image