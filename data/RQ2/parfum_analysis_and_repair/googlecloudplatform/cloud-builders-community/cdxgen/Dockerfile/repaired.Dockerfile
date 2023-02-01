FROM gcr.io/cloud-builders/npm
RUN npm install -g @appthreat/cdxgen && npm cache clean --force;

ENTRYPOINT ["cdxgen"]
