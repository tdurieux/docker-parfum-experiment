FROM node:8

RUN npm install -g yarn && npm cache clean --force;
RUN bash -c "cd /volume && yarn install"
