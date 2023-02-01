FROM node:14-buster-slim AS builder
RUN apt-get update && apt-get install --no-install-recommends -y curl unzip && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/node
USER node
COPY --chown=node sdk sdk
RUN cd sdk && npm ci
RUN cd sdk && npm pack
COPY --chown=node tck/package.json tck/
COPY --chown=node tck/bin tck/bin
RUN cd tck && npm install && npm cache clean --force;
COPY --chown=node tck tck
RUN cd tck && npm run build
RUN cd tck && npm prune --production

FROM node:14-buster-slim
COPY --from=builder --chown=node /home/node /home/node
WORKDIR /home/node/tck
USER node
ENV HOST 0.0.0.0
ENV NODE_ENV production
ENV DEBUG kalix*
EXPOSE 8080
CMD ["node", "dist/index.js"]
