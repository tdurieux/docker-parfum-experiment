FROM base as build

COPY --slim ./package.json ./
RUN npm install && npm cache clean --force;

COPY ./package.json ./
RUN npm run build
