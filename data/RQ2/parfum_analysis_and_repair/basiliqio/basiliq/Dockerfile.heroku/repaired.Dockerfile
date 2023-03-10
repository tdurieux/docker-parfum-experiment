FROM registry.gitlab.com/basiliqio/basiliq/basiliq AS bin

FROM busybox

COPY --from=bin /app/basiliq /app/basiliq

COPY utils/heroku_entry.sh /app/entry.sh

CMD [ "/app/entry.sh" ]