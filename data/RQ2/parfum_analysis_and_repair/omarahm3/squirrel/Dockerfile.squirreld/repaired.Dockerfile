FROM alpine

COPY squirreld /usr/bin/squirreld

CMD [ "/usr/bin/squirreld" ]