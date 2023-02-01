FROM node:alpine
LABEL maintainer="Jay MOULIN <jaymoulin@gmail.com> <https://twitter.com/MoulinJay>"
COPY * /
RUN yarn install && yarn cache clean;

ENTRYPOINT ["/index.js"]
CMD []
