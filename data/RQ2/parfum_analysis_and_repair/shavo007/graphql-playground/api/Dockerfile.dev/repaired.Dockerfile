# ---- Base Node ----
FROM node:11.7.0-alpine AS base
LABEL maintainer="shane lee"
RUN apk --no-cache update \
&& apk --no-cache  add --virtual builds-deps build-base python \
&& mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# copy project file
COPY package.json /usr/src/app
COPY yarn.lock /usr/src/app


#
# ---- Release ----
FROM base AS release
COPY . .
RUN yarn && yarn cache clean;

# expose port and define CMD
ENV DATABASE=postgres
ENV DATABASE_USER=postgres
ENV DATABASE_PASSWORD=mysecretpassword
ENV SECRET=wr3r23fwfwefwekwself.2456342.dawqdq
ENV DB_HOST=some-postgres

EXPOSE 8000
CMD yarn start
