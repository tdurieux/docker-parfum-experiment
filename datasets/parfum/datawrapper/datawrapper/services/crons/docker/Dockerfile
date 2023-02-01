FROM node:14-alpine

RUN npm install -g nodemon

RUN	ln -s /datawrapper/code/libs /usr/local/lib/node_modules/@datawrapper && \
	mkdir /etc/datawrapper && \
	ln -s /datawrapper/code/config.js /etc/datawrapper/config.js && \
	ln -s /datawrapper/code/config.local.js /etc/datawrapper/config.local.js

WORKDIR /datawrapper/code/services/crons
USER node

ENTRYPOINT ["/datawrapper/code/services/crons/docker/entrypoint.sh"]
CMD ["/datawrapper/code/services/crons/scripts/start"]
