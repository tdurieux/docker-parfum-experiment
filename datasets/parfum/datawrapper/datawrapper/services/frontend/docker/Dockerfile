FROM node:14-alpine

RUN	ln -s /datawrapper/code/libs /usr/local/lib/node_modules/@datawrapper && \
	mkdir /etc/datawrapper && \
	ln -s /datawrapper/code/config.js /etc/datawrapper/config.js && \
	ln -s /datawrapper/code/config.local.js /etc/datawrapper/config.local.js

WORKDIR /datawrapper/code/services/frontend
USER node

ENTRYPOINT ["/datawrapper/code/services/frontend/docker/entrypoint.sh"]
CMD ["/datawrapper/code/services/frontend/src/server.js"]
