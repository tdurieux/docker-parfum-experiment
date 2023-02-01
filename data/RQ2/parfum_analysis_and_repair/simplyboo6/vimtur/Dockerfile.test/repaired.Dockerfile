ARG PRE_IMAGE
FROM $PRE_IMAGE

RUN apk add --no-cache docker

ENTRYPOINT ["/app/run-tests.sh"]
