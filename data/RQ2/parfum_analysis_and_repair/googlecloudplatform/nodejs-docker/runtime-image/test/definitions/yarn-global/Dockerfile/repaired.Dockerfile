FROM test/nodejs
COPY . /app/
RUN npm install --global yarn@1.12.3 && npm cache clean --force;
RUN yarn install --production || \
  ((if [ -f yarn-error.log ]; then \
      cat yarn-error.log; \
    fi) && false) && yarn cache clean;
CMD yarn start
