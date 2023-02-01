FROM 	vikings/alpine:base
LABEL 	MAINTAINER=ztao8607@gmail.com
RUN apk --update --no-cache add caddy
EXPOSE  80
ENTRYPOINT ["caddy"]