FROM node
LABEL MAINTAINER="Paolo Casciello <paolo.casciello@scalebox.it>"

ENV NODE_ENV development

WORKDIR /workspace

RUN npm install yarn --global --force && npm cache clean --force;
RUN yarn global add gulp && yarn cache clean;

EXPOSE 3000
EXPOSE 3001

# watch
CMD ["gulp", "monitor"]
