FROM node:8 as production
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production && npm cache clean --force;

FROM production as build
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build

FROM node:8
WORKDIR /app
VOLUME /sqrl
COPY --from=production /app /app
COPY --from=build /app/lib /app/lib
RUN ln -s /app/lib/cli.js /usr/local/bin/sqrl

EXPOSE 2288
CMD [ "sqrl" ]
