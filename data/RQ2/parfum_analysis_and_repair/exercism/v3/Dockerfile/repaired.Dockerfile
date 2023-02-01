FROM node:12
RUN npm install -g docsify-cli && npm cache clean --force;

# https://github.com/docsifyjs/docsify-cli/issues/78
RUN apt-get update \
	&& apt-get install -y --no-install-recommends dos2unix \
	&& dos2unix /usr/local/lib/node_modules/docsify-cli/bin/docsify && rm -rf /var/lib/apt/lists/*;

EXPOSE 3005
USER node

WORKDIR /opt/exercism-docsify

ENTRYPOINT docsify serve -p 3005 .
