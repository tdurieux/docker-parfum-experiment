FROM alpine:3.7

RUN apk add --no-cache curl
COPY ./local-test-driver.sh .
RUN chmod +x local-test-driver.sh
CMD ./local-test-driver.sh