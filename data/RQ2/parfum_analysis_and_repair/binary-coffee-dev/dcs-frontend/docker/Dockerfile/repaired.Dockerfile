FROM node:14.18.0-alpine3.11

WORKDIR /app

COPY package.json ./
RUN npm install && npm cache clean --force;

COPY . ./

ARG ENVIRONMENT
RUN if [ "$ENVIRONMENT" = "dev" ] ; then npm run build:ssr:dev ; else npm run build:ssr ; fi

CMD ["npm", "run", "serve:ssr"]
