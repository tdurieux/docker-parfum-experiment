FROM mhart/alpine-node:8.11.2

WORKDIR /opt
COPY . /opt
ENV NODE_ENV=production

RUN cp server/config/env/secrets-template.js server/config/env/secrets.js

RUN npm install && npm cache clean --force;
RUN npm run build

CMD ["npm", "start"]
EXPOSE 3000
