FROM alpine

COPY --chown=${BOGUS}:${BOGUS} copychown.txt /tmp
CMD /bin/sh