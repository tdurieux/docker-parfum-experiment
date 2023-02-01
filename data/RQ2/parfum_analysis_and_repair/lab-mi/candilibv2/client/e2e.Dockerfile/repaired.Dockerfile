#######################
# Step 1: Base target #
#######################
FROM cypress/browsers:node16.14.0-chrome99-ff97 as base
ARG http_proxy
ARG https_proxy
ARG npm_registry
ARG no_proxy

# Base dir /app
WORKDIR /app

RUN ln -snf /usr/share/zoneinfo/Europe/Paris /etc/localtime && echo "Europe/Paris" > /etc/timezone
# use proxy & private npm registry
RUN if [ ! -z "$http_proxy" ] ; then \
        npm config delete proxy; \
        npm config set proxy $http_proxy; \
        npm config set https-proxy $https_proxy; \
        npm config set no-proxy $no_proxy; \
   fi ; \
   [ -z "$npm_registry" ] || npm config set registry=$npm_registry; \
   [ -z "$npm_registry" ] || npm config set strict-ssl false ; \
   [ -z "$sass_registry" ] || npm config set sass-binary-site=$sass_registry;

################################
# Step 2: "development" target #
################################
FROM base as development
ARG CYPRESS_DOWNLOAD_MIRROR
ARG APP_VERSION
ENV CI=1
COPY src src/
COPY tests tests/
COPY package.json package-lock.json ./
COPY cypress.json cypress.env.json ./
COPY e2e-entrypoint.sh /e2e-entrypoint.sh
# Install app dependencies
RUN ssl="$(npm config get strict-ssl)" ; [ "x$ssl" = "xfalse" ] && export NODE_TLS_REJECT_UNAUTHORIZED=0 || true ; \
    npm --no-git-tag-version version ${APP_VERSION} ; npm install cypress-file-upload && npm cache clean --force;
RUN [ -f /e2e-entrypoint.sh ]&& chmod +x /e2e-entrypoint.sh

#CMD ["npm","run", "cypress"]
ENTRYPOINT ["/e2e-entrypoint.sh"]
