# Stage for building application
FROM node:alpine AS dev

COPY . /dt
WORKDIR /dt
RUN yarn workspaces focus @datatorch/web

WORKDIR /dt/clients/web
RUN yarn build

# Production enviroment
FROM node:alpine AS production
ENV NODE_ENV=production

COPY .yarn /dt/.yarn
COPY .yarnrc.yml /dt
COPY yarn.lock /dt
COPY package.json /dt

RUN mkdir -p /dt/clients/web
COPY clients/web/package.json /dt/clients/web
COPY clients/web/next.config.js /dt/clients/web

COPY --from=dev /dt/clients/web/.next /dt/clients/web/.next
COPY --from=dev /dt/.yarn /dt/.yarn

WORKDIR /dt
RUN yarn workspaces focus @datatorch/web

WORKDIR /dt/clients/web

CMD ["yarn", "workspace", "@datatorch/web", "start"]

EXPOSE 3000

HEALTHCHECK CMD ["curl", "localhost:3000"]
