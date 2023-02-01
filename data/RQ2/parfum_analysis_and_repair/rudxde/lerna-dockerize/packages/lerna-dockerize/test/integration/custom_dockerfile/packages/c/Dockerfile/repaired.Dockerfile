FROM --platform=arm64 base as build

COPY --slim ./package.json ./
RUN npm install && npm cache clean --force;

COPY ./package.json ./

COPY ./build.sh ./

RUN ./build.sh
