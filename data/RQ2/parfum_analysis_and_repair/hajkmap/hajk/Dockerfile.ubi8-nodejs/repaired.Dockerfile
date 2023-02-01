# Stage 1 - Building the backend
FROM registry.access.redhat.com/ubi8/nodejs-16 as backendBuilder
COPY /new-backend/package*.json ./
USER root
RUN npm install && npm cache clean --force;
COPY ./new-backend .
RUN npm run compile

# Stage 2 - Building the client
FROM registry.access.redhat.com/ubi8/nodejs-16 as clientBuilder
COPY /new-client/package*.json ./
USER root
RUN npm install --ignore-scripts && npm cache clean --force;
COPY ./new-client .
RUN rm ./public/appConfig.json
RUN mv ./public/appConfig.docker.json ./public/appConfig.json
RUN npm run build --ignore-scripts

# Stage 3 - Building the admin
FROM registry.access.redhat.com/ubi8/nodejs-16 as adminBuilder
COPY /new-admin/package*.json ./
USER root
RUN npm install && npm cache clean --force;
COPY ./new-admin .
RUN rm ./public/config.json
RUN mv ./public/config.docker.json ./public/config.json
RUN npm run build

# Stage 4 - Combine everything and fire it up
FROM registry.access.redhat.com/ubi8/nodejs-16-minimal
COPY /new-backend/package*.json ./
USER root
RUN npm install --production && npm cache clean --force;
USER 1001
COPY --from=backendBuilder /opt/app-root/src/dist ./
COPY /new-backend/.env .
COPY /new-backend/App_Data ./App_Data
COPY /new-backend/static ./static
COPY --from=clientBuilder /opt/app-root/src/build ./static/client
COPY --from=adminBuilder /opt/app-root/src/build ./static/admin
USER root
RUN chown -R 1001 ./App_Data
VOLUME /opt/app-root/src/App_Data
EXPOSE 3002
USER 1001
CMD node index.js

# See HAJK Docker/README.md for example usage
