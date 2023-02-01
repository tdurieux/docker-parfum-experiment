# stage 1 build
FROM alpine:3.12.3 AS cpprest-base-image

RUN apk add --no-cache curl build-base bash git boost-dev cmake zlib-dev openssl-dev ninja

RUN rm -rf /app;mkdir -p /app
	
WORKDIR /app

ADD skip-tests.patch .
RUN git clone https://github.com/Microsoft/cpprestsdk.git casablanca
        # apply patch to skip un-wanted tests and compile