FROM koush/scrypted-common

WORKDIR /
COPY . .

WORKDIR /server
RUN npm install && npm cache clean --force;
RUN npm run build

CMD npm run serve-no-build
