FROM node:12-alpine AS prod

WORKDIR /usr/src/app

# Add package.json
COPY package*.json .

RUN apk update && apk add --no-cache --virtual build-dependencies build-base git python

# Restore node modules
RUN npm install --production && npm cache clean --force;



## BUILD STEP
FROM prod AS build

# Add everything else not excluded by .dockerignore
COPY . .

# Build it
RUN npm install && \
    npm run build-prod && npm cache clean --force;



## FINAL STEP
FROM prod as final

RUN apk del build-dependencies

COPY --from=build /usr/src/app/dist ./dist
COPY www/ ./www/

EXPOSE 3000
CMD [ "node", "dist/server.js" ]
