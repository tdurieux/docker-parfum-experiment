# The official nodejs docker image
FROM node:14.17.3

ENV PYTHON /usr/bin/python

# Copy package.json only to temp folder, install its dependencies,
# set workdir and copy the dependnecies there
# This way, dependnecies are cached without the need of cacheing all files.

COPY .npmrc /tmp/.npmrc 
ADD package.json /tmp/package.json
RUN set -ex \
	&& cd /tmp \
	&& yarn install \
	&& rm -f /tmp/.npmrc \
	&& mkdir -p /home/app \
	&& cp -a /tmp/node_modules /home/app/ \
	&& rm -Rf /tmp/* && yarn cache clean;

WORKDIR /home/app

# Copy the rest of the files to the container workdir
ADD . /home/app

ENV PORT=8080
EXPOSE ${PORT}

CMD ["yarn", "start"]
