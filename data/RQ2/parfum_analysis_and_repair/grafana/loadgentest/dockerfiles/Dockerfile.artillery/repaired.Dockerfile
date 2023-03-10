FROM alpine:latest

ENV ARTILLERY_VERSION 1.6.0-28

RUN apk --update --no-cache add \
	nodejs-current \
	nodejs-current-npm

RUN npm install -g artillery@${ARTILLERY_VERSION} --unsafe-perm=true --allow-root && npm cache clean --force;

ENTRYPOINT ["artillery"]
CMD ["--help"]
