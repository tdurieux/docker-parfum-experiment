FROM node:16-bullseye-slim AS BUILD

# git is needed to install Half-Shot/slackdown
RUN apt update && apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
WORKDIR /src

COPY package.json package-lock.json /src/
RUN npm ci --ignore-scripts
COPY . /src
RUN npm run build

FROM node:16-bullseye-slim

VOLUME /data/ /config/

WORKDIR /usr/src/app
COPY package.json package-lock.json /usr/src/app/
RUN apt update && apt install --no-install-recommends git -y && npm ci --only=production --ignore-scripts && rm -rf /var/lib/apt/lists/*;

COPY --from=BUILD /src/config /usr/src/app/config
COPY --from=BUILD /src/templates /usr/src/app/templates
COPY --from=BUILD /src/lib /usr/src/app/lib

EXPOSE 9898
EXPOSE 5858

ENTRYPOINT [ "node", "lib/app.js", "-c", "/config/config.yaml" ]
CMD [ "-f", "/config/slack-registration.yaml" ]
