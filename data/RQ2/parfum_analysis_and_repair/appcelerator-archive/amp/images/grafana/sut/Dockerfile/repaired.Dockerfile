From appcelerator/alpine:3.7.0
RUN apk --update --no-cache add docker@community
COPY ./test.sh /bin
CMD ["/bin/test.sh"]
