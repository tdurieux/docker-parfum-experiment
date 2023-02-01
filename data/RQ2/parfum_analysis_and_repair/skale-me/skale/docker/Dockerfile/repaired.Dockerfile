from alpine:edge

RUN apk add --no-cache nodejs nodejs-npm; \
	npm install -g skale; npm cache clean --force; \
	apk del nodejs-npm; \
	adduser -D skale

ADD run.sh /

ENTRYPOINT [ "/run.sh" ]
CMD [ "sh" ]
