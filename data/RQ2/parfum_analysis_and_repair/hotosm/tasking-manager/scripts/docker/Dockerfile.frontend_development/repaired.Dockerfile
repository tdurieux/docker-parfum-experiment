FROM alpine/git as base

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Get the Tasking Manager
ARG branch=master
RUN git clone --depth=1 git://github.com/hotosm/tasking-manager.git \
	--branch $branch /usr/src/app

RUN rm -rf backend/ migrations/

FROM tiangolo/node-frontend:10 as build

WORKDIR /usr/src/app

COPY --from=base /usr/src/app/frontend /usr/src/app

## SETUP
RUN npm install && npm cache clean --force;

ARG TM_APP_API_URL=http://localhost/api
ARG TM_IMPORT_MAX_FILESIZE=1000000
ARG TM_MAX_AOI_AREA=5000

# SERVE
CMD ["npm", "start"]

