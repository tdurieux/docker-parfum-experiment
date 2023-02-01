ARG BASE="16-bullseye"
FROM koush/scrypted-common:${BASE}

WORKDIR /
RUN git clone --depth=1 https://github.com/koush/scrypted

WORKDIR /scrypted/server
RUN npm install && npm cache clean --force;
RUN npm run build

CMD npm run serve-no-build
