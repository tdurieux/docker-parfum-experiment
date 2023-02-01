FROM stream.place/sp-node

ENV NODE_ENV development
ONBUILD ADD package.json /app/package.json
 \
RUN npm install --no-scripts && npm cache clean --force; ONBUILD
ONBUILD COPY src /app/src
ONBUILD COPY public /app/public
