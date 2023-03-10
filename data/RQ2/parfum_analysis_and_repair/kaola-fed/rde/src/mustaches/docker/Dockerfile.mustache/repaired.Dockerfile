FROM {{{from}}}

COPY .cache/version {{{workDir}}}/

RUN npm config set registry http://registry.npm.taobao.org

RUN npm i -g rde --registry=http://registry.npm.taobao.org && npm cache clean --force;

RUN groupadd rde && useradd -ms /bin/bash -g rde {{#uid}}-u {{{uid}}}{{/uid}} rde

WORKDIR {{{workDir}}}

COPY .cache/package-cache.json template/.npmrc* template/.yarnrc* app/.npmrc* app/.yarnrc* {{{workDir}}}/

RUN mv package-cache.json package.json

COPY .cache/package-cache.json app/.npmrc* {{{workDir}}}/template/

RUN chown -R rde:rde {{{workDir}}}

{{!cache node-modules}}
USER rde

ENV HOME {{{workDir}}}

RUN npm i && npm cache clean --force;
