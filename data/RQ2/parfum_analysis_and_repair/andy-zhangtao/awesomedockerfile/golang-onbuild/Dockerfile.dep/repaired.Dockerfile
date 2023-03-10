FROM	golang:1.11-alpine3.7
LABEL 	MAINTAINER=ztao@gmail.com
RUN apk update && \
		apk add --no-cache git expect curl && \
		go get -u github.com/golang/dep/cmd/dep
COPY 	entrypoint-dep.sh /entrypoint.sh
ENTRYPOINT ["/bin/sh","/entrypoint.sh"]
