# use latest Node LTS (Erbium)
FROM node:erbium
# install Firebase CLI
RUN npm install -g firebase-tools && npm cache clean --force;

ENTRYPOINT ["/usr/local/bin/firebase"]
