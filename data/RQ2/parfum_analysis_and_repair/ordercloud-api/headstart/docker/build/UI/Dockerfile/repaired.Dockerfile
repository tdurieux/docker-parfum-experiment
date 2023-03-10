ARG BASE_IMAGE

FROM ${BASE_IMAGE} as base

RUN npm config set registry http://registry.npmjs.org/ --global

RUN npm install -g json && npm cache clean --force;

RUN apk add --no-cache git

FROM base as builder

ARG ROLE

WORKDIR /build

# Build SDK
COPY src/UI/SDK/package*.json SDK/
RUN cd /build/SDK && npm install && npm cache clean --force;
COPY src/UI/SDK SDK/
RUN cd /build/SDK && npm run build

# Build APP (Buyer or Seller)
# Note: Doesn't seem to be run npm install as a separate layer because its required to symlink sdk
COPY src/UI/${ROLE} APP/
RUN cd /build/APP && npm install && npm cache clean --force;
RUN sed -i 's/useLocalMiddleware = true/useLocalMiddleware = false/g' /build/APP/src/environments/environment.local.ts
RUN cd /build/APP && npm run build --prod

FROM nginx:1.19.8-alpine as production

ARG ROLE

COPY docker/build/UI/${ROLE}.sh ./entrypoint.sh

RUN apk add --no-cache dos2unix && dos2unix ./entrypoint.sh

RUN apk add --no-cache --update nodejs nodejs-npm && npm install -g json && npm cache clean --force;

COPY docker/build/UI/nginx/default.conf /etc/nginx/conf.d/default.conf

COPY src/UI/${ROLE}/scripts /usr/share/nginx/html

COPY --from=builder /build/APP/dist /usr/share/nginx/html

RUN ["chmod", "+x", "./entrypoint.sh"]

CMD ["sh", "/entrypoint.sh"]
