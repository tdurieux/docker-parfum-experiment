FROM registry.yakshaving.art:443/tools/multiarch-alpine-base:latest

COPY alertsnitch-arm /alertsnitch

EXPOSE 9567

ENTRYPOINT [ "/alertsnitch" ]