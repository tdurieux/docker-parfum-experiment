FROM alpine/git:latest AS pull
RUN git clone https://github.com/edgelesssys/marblerun.git /marble-injector
WORKDIR /marble-injector

FROM ghcr.io/edgelesssys/edgelessrt-dev AS build
COPY --from=pull /marble-injector /marble-injector
WORKDIR /marble-injector/build
RUN cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
RUN make marble-injector

FROM scratch AS release
LABEL description="EdgelessMarbleInjector"
COPY --from=build /marble-injector/build/marble-injector /
ENTRYPOINT [ "/marble-injector" ]