FROM alpine
MAINTAINER mcottret@itrust.fr
RUN apk --update --no-cache add socat
USER nobody
ENTRYPOINT ["socat"]
CMD ["-h"]
