FROM node:10-stretch as build
COPY . /wstunnel
RUN cd /wstunnel && npm install --production && npm cache clean --force;

FROM node:10-alpine
COPY --from=build /wstunnel /wstunnel
WORKDIR /wstunnel
ENTRYPOINT ["node", "/wstunnel/bin/wstt.js"]
