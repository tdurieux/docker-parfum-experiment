FROM node
RUN mkdir /opt/domain-availability
COPY ./ /opt/domain-availability/
RUN chown -R node:node /opt/domain-availability
USER node
WORKDIR /opt/domain-availability
RUN npm install && npm cache clean --force;
RUN npm install grunt-cli && npm cache clean --force;
RUN node_modules/.bin/grunt copy
EXPOSE 3000
ENTRYPOINT ["npm", "start"]
