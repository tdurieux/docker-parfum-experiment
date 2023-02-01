FROM node:fermium AS build

RUN apt-get update && \
    apt-get install --no-install-recommends zip -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app

COPY ./*.json /app/
RUN npm install && npm cache clean --force;

COPY ./src /app/src
RUN npm run build

WORKDIR /app/src
RUN zip -r ../out/static/source.zip .

FROM node:fermium

RUN apt-get update && \
    apt-get install --no-install-recommends redis-server -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app

ENV NODE_ENV production

COPY --from=build /app/package* /app/
COPY --from=build /app/node_modules /app/node_modules

COPY --from=build /app/out /app

RUN npm prune

COPY ./entrypoint.sh /

ENV SECRET=Wn7D4NYgt0A72VK6Jwjj8jOFwmWVz3D73Bjwrz88SHe1IuyxtjxtdxAhy8zU

RUN chown node:node /app/userdata
RUN mkdir /app/userdata/admin
RUN echo "FLAG-TALKING_TO_REDIS_THROUGH_FTP" > /app/userdata/admin/flag

USER node
CMD [ "/entrypoint.sh" ]
