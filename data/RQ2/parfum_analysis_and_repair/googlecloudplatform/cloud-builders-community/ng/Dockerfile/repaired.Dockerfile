FROM node:current

ARG ng_version=latest
RUN npm install -g @angular/cli@$ng_version --unsafe-perms && \
    ng version && npm cache clean --force;

ENTRYPOINT ["ng"]
