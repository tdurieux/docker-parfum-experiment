FROM node:12-buster-slim

WORKDIR /frontail
ADD . .
RUN npm install --production && npm cache clean --force;

ENTRYPOINT ["/frontail/docker-entrypoint.sh"]
EXPOSE 9001
CMD ["--help"]
