FROM node:8-alpine

# install chromium for headless browser tests
ENV CHROME_BIN=/usr/bin/chromium-browser
RUN apk add --no-cache chromium udev ttf-freefont

# set workdir
WORKDIR /ffdl/ffdl-dashboard

# fix npm permission issues (https://github.com/creationix/nvm/issues/1407#issuecomment-316858947)
RUN npm config set user 0
RUN npm config set unsafe-perm true
# install global dependencies
# RUN npm install --quiet -g @angular/cli
RUN npm install --quiet -g @angular/cli@6.0.8 && npm cache clean --force;
RUN npm install --quiet -g http-server && npm cache clean --force;

# set non-root user
RUN chown -R node:node .
USER node

# install local dependencies
ADD package.json ./
RUN npm install --quiet && npm cache clean --force;

# add source files
ADD .angular-cli.json .editorconfig karma.conf.js package-lock.json \
  protractor.conf.js README.md tsconfig.json tslint.json ./
ADD e2e/ ./e2e/
ADD src/ ./src/

# create production build
RUN ng build --prod

# clean up (make sure to squash the image afterwards!)
RUN rm -r ./node_modules /home/node/./.npm

EXPOSE 8080

CMD ["http-server", "./dist"]
