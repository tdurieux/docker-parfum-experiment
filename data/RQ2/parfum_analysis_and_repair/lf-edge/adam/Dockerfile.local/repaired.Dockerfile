FROM lfedge/eve-alpine:6.2.0 as build
ENV PKGS alpine-baselayout
RUN eve-alpine-deploy.sh

WORKDIR /out
COPY scripts /bin
COPY samples /adam
COPY ./bin/adam-linux-amd64 /bin/adam

FROM scratch
COPY --from=build /out/ /
WORKDIR /adam
ENTRYPOINT ["/bin/adam"]