FROM node:alpine

RUN npm install --global \
	clean-css-cli \
	uglify-js && npm cache clean --force;
