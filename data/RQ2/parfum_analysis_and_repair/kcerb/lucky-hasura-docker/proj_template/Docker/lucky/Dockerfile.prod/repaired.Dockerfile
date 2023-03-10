FROM luckyhasuradocker/lucky-crystal:l0.24.0c0.35.1-alpine

RUN addgroup -g 1000 -S lucky && \
    adduser -u 1000 -S lucky -G lucky
USER lucky

COPY --chown=lucky:lucky shard.* /home/lucky/app/
WORKDIR /home/lucky/app

# After this point the file differs from dev
RUN shards install --production
COPY --chown=lucky:lucky . /home/lucky/app
RUN crystal build script/docker/lucky_healthcheck.cr -o script/docker/lucky_healthcheck
RUN crystal build script/docker/last_migration_timestamp.cr -o script/docker/last_migration_timestamp
RUN crystal build --release src/start_server.cr
RUN crystal build tasks.cr -o tasks/run_task
CMD ["/home/lucky/app/start_server"]