FROM node:lts-alpine

RUN apk add --no-cache git python3 build-base
RUN npm i -g --force yarn && npm cache clean --force;
COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
