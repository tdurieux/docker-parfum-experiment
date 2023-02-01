FROM lfedge/eve-alpine:6.6.0 as build
ENV BUILD_PKGS go make qemu-img git
RUN eve-alpine-deploy.sh

# FIXME bump eve-alpine to alpine 3.14
# hadolint ignore=DL3018
RUN apk --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/v3.14/community add -U --upgrade go && go version

ARG OS=linux
ENV CGO_ENABLED=0
WORKDIR /eden
COPY . /eden
RUN make DO_DOCKER=0 OS=${OS} build-tests
RUN mkdir /out/eden && cp -rf /eden/eden /eden/dist /eden/docs /eden/README.md /out/eden
COPY tests /out/eden/tests
RUN cp /etc/passwd /etc/group /out/etc/

FROM scratch
COPY --from=build /out/ /
WORKDIR /eden
CMD ["/bin/sh"]
