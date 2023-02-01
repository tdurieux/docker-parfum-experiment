FROM  vikings/golang:1.9-onbuild
RUN apk --update --no-cache add mongodb && \
      rm /usr/bin/mongoperf
VOLUME 	/data/db
COPY  entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
