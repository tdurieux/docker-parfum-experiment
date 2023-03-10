FROM keymetrics/pm2:latest-alpine

# Bundle APP files
COPY . .

# Install app dependencies
ENV NPM_CONFIG_LOGLEVEL warn
RUN npm install --production && npm cache clean --force;

CMD [ "pm2-runtime", "app.js" ]
