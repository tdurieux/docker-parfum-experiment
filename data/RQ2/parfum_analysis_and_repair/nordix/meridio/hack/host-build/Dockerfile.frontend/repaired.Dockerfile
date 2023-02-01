ARG base_image=registry.nordix.org/cloud-native/meridio/base:1.0.0
FROM ${base_image}
RUN apk add --no-cache bird
RUN mkdir -p /run/bird && mkdir -p /etc/bird
COPY . .
CMD ["/root/start-command"]
