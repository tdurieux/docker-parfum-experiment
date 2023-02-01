FROM base as build

COPY --slim ./package.json ./
RUN npm i --no-ci && npm cache clean --force;

COPY ./package.json ./
RUN npm run build
