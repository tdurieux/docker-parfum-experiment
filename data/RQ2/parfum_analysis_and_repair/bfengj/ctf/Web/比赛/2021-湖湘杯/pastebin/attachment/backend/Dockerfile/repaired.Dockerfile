FROM node:16

RUN apt update && apt install --no-install-recommends -y libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev libasound2 && rm -rf /var/lib/apt/lists/*;
# install dependencies
RUN ["mkdir", "/install"]
ADD ["./package.json", "/install"]
WORKDIR /install
RUN npm install -y yarn && npm cache clean --force;
# RUN npm config set strict-ssl false && npm install -y yarn
# RUN yarn config set "strict-ssl" false --global
RUN yarn && yarn global add nodemon
# RUN npm install -g nodemon
ENV NODE_PATH=/install/node_modules

WORKDIR /app

USER 1000

CMD npm run $NPM_RUN_SCRIPT
