FROM node:16.16-alpine

{{#build_deps}}
  RUN apk add --no-cache {{{.}}}
{{/build_deps}}

RUN npm -g install pm2 && npm cache clean --force;

WORKDIR /usr/src/app

{{#files}}
  COPY {{{.}}} {{{.}}}
{{/files}}
{{^files}}
  COPY app.js package.json ./
{{/files}}

ENV NODE_ENV production

{{#bin_deps}}
  RUN apk add --no-cache {{{.}}}
{{/bin_deps}}

{{#fixes}}
  RUN {{{.}}}
{{/fixes}}

RUN npm install && npm cache clean --force;

{{#before_command}}
  RUN {{{.}}}
{{/before_command}}

{{#environment}}
  ENV {{{.}}}
{{/environment}}

{{#command}}
  CMD {{{.}}}
{{/command}}

{{^command}}
  CMD pm2-runtime start app.js -i $(nproc)
{{/command}}
