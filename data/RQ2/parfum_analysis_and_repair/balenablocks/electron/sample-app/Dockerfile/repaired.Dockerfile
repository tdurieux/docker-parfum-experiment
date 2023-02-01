FROM balena-electron-env

COPY package.json package-lock.json ./
RUN npm i --production && npm cache clean --force;
RUN npm i electron && npm cache clean --force;
COPY index.js index.html renderer.js ./
