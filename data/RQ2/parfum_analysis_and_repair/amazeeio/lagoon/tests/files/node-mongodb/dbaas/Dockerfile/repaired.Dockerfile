ARG UPSTREAM_REPO
ARG UPSTREAM_TAG

FROM ${UPSTREAM_REPO:-testlagoon}/node-16:${UPSTREAM_TAG:-latest}
COPY . /app/

RUN npm install && npm cache clean --force;

EXPOSE 3000

CMD ["node", "index.js"]
