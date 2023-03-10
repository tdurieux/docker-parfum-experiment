FROM local/yarn-runner

COPY --chown=docker:docker --from=local/cache-helper-collect-packages /tmp/dst ${APP_HOME}
RUN yarn build:packages && yarn cache clean;
