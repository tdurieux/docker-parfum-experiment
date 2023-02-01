FROM node:16.10

ARG UNIFLOW_VERSION

RUN if [ -z "$UNIFLOW_VERSION" ] ; then echo "The UNIFLOW_VERSION argument is missing!" ; exit 1; fi

RUN \
	apt-get update && \
	apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

# Set a custom user to not have uniflow run as root
USER root

RUN npm_config_user=root npm install -g @uniflow-io/uniflow-api@${UNIFLOW_VERSION} && npm cache clean --force;

# fix and install dev dependancies
RUN npm_config_user=root npm install -g faker && npm cache clean --force;

WORKDIR /data

#COPY .env /usr/local/lib/node_modules/@uniflow-io/uniflow-api/.env.development
COPY .env .env.development
## quick path fix
RUN sed -i 's#./public#/usr/local/lib/node_modules/@uniflow-io/uniflow-api/public#g' /usr/local/lib/node_modules/@uniflow-io/uniflow-api/dist/loader/server-loader.js

EXPOSE 8017/tcp
