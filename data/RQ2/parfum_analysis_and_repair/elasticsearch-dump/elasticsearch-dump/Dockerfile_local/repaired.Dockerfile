FROM node:14-buster-slim
LABEL maintainer="ferronrsmith@gmail.com"
ENV NODE_ENV production
WORKDIR /app

COPY . .
RUN npm install --production -g && npm cache clean --force;

RUN rm /usr/local/bin/docker-entrypoint.sh && \
  ln -s /app/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["elasticdump"]