From appcelerator/alpine:3.5.1
RUN apk --update --no-cache add docker@community
COPY ./test.sh /bin
CMD ["/bin/test.sh"]
