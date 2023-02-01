FROM wechaty/wechaty:next

ONBUILD ARG NODE_ENV
ONBUILD ENV NODE_ENV $NODE_ENV

ONBUILD WORKDIR /bot

ONBUILD COPY package.json .
 \
RUN jq 'del(.dependencies.wechaty)' package.json | sponge package.json \
    && npm install \
    && sudo rm -fr /tmp/* ~/.npm && npm cache clean --force; ONBUILD


ONBUILD COPY . .
ONBUILD RUN npm run build --if-present

CMD [ "npm", "start" ]
