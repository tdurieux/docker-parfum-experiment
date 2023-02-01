FROM alpine:3.7
COPY test.sh .
RUN apk add --no-cache curl bash
CMD ["./test.sh"]
