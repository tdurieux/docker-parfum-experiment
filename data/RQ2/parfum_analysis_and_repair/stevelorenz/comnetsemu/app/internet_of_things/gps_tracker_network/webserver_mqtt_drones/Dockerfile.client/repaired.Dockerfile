FROM alpine:3.12

RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash \
        bash-completion \
        links \
        curl

WORKDIR /root
CMD ["bash"]
