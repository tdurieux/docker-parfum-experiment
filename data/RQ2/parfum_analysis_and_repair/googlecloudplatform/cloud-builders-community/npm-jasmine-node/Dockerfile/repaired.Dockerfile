FROM gcr.io/cloud-builders/npm
RUN npm install -g jasmine-node && npm cache clean --force;
ENTRYPOINT ["npm"]
