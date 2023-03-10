FROM node:16-bullseye-slim

WORKDIR /app
RUN npm install directus@9.9.1 --global && npm cache clean --force;
COPY ./apps/cms .
COPY ./docker/deploy/cms/run.sh .

CMD ["./run.sh"]
