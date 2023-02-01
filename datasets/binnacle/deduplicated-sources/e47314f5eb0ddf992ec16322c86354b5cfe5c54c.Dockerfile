FROM alpine:3.9.2

## apk
RUN apk add wget curl

## use the / directory
WORKDIR /

## download the vproxy runtime
## extract (the extract result would be a directory "./vproxy-runtime-musl")
## remove the tar.gz file
RUN wget -q https://github.com/wkgcass/vproxy/releases/download/1.0.0-ALPHA-4/vproxy-runtime-musl.tar.gz && \
    tar zxf vproxy-runtime-musl.tar.gz && \
    rm -f vproxy-runtime-musl.tar.gz

## download the latest vproxy
RUN curl https://raw.githubusercontent.com/wkgcass/vproxy/master/src/main/java/vproxy/app/Application.java 2>/dev/null \
    | grep '_THE_VERSION_' \
    | awk '{print $3}' \
    | cut -d '"' -f 2 \
    1> /version
RUN wget -q https://github.com/wkgcass/vproxy/releases/download/$(cat /version)/vproxy-$(cat /version).jar && \
    mv vproxy-$(cat /version).jar vproxy.jar

## set path variable
ENV PATH="/vproxy-runtime-musl/bin:$PATH"

## default we start the vproxy with a resp-controller
CMD ["java", \
     "-jar", "/vproxy.jar", \
     "resp-controller", "0.0.0.0:16379", "123456", \
     "allowSystemCallInNonStdIOController", \
     "noStdIOController" \
    ]
