FROM alpine

COPY squirrel /usr/bin/squirrel

CMD [ "/usr/bin/squirrel" ]