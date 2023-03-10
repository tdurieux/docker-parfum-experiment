FROM node:16.0.0

RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /opt/web && chown -R node:node /opt/web \
  && mkdir -p /opt/server && chown -R node:node /opt/server \
  && mkdir -p /opt/scripts && chown -R node:node /opt/scripts \
  && nginx -t \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log \
  && chown -R node:node /run/nginx.pid \
  && chown -R node:node /var/lib/nginx \
  && npm install -g node-dev && npm cache clean --force;

COPY nginx/development.conf /etc/nginx/nginx.conf

EXPOSE 8140
