FROM base as build

COPY --slim ./package.json ./
RUN npm install && npm cache clean --force;

COPY ./package.json ./

COPY --if-exists ./build.sh ./

RUN --if-exists npm run build
RUN --if-exists ./build.sh
