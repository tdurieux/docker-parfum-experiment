FROM local/ruby-runner

COPY --chown=docker:docker --from=local/cache-helper-collect-yarn /tmp/dst ${APP_HOME}

RUN set -eux; \
  (DISABLE_POSTINSTALL=1 yarn install --pure-lockfile || DISABLE_POSTINSTALL=1 yarn install --pure-lockfile --network-concurrency 1) \
  && yarn cache clean \
  && ./script/fix_inst_esm.js