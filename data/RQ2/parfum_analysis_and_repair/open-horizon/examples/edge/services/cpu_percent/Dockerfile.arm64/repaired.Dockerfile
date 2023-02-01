FROM aarch64/alpine:latest
RUN apk --no-cache --update add gawk bc socat curl 
COPY *.sh /
WORKDIR /
RUN addgroup -S hzngroup && adduser -S hznuser -G hzngroup
USER hznuser
EXPOSE 8080
CMD /start.sh