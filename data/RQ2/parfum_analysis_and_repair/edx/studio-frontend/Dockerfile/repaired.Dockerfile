FROM node:16

USER root
RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN npm i -g npm@8.x.x && npm cache clean --force;

WORKDIR /prebuilt
COPY config/ config/
COPY src/accessibilityIndex.jsx src/accessibilityIndex.jsx
COPY src/courseHealthCheckIndex.jsx src/courseHealthCheckIndex.jsx
COPY src/courseOutlineHealthCheckIndex.jsx src/courseOutlineHealthCheckIndex.jsx
COPY src/data/i18n/locales src/data/i18n/locales
COPY src/editImageModalIndex.jsx src/editImageModalIndex.jsx
COPY src/index.jsx src/index.jsx
COPY package.json .
RUN npm install && npm cache clean --force;

WORKDIR /studio-frontend
ENTRYPOINT cp -r /prebuilt/node_modules /studio-frontend/ && \
    npm install && \
    npm run start

EXPOSE 18011
