FROM node:16-bullseye

ENV NODE_ENV=production

COPY . /usr/local/share/file-manager
RUN cd /usr/local/share/file-manager \
	&& npm install . \
	&& rm -rf ~/.npm ~/.cache && npm cache clean --force;

WORKDIR /data

CMD ["node", "/usr/local/share/file-manager/index.js"]
