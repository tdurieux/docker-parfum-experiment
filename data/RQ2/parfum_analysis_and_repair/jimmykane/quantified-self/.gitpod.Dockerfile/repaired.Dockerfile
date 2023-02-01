FROM gitpod/workspace-full

RUN npm install --global npm firebase firebase-tools && npm cache clean --force;
