# syntax=docker/dockerfile:experimental

FROM alpine/git:latest AS pull
RUN git clone https://github.com/edgelesssys/marblerun.git /coordinator

FROM ghcr.io/edgelesssys/edgelessrt-dev AS build
COPY --from=pull /coordinator /coordinator
WORKDIR /coordinator/build
RUN cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
RUN --mount=type=secret,id=signingkey,dst=/coordinator/build/private.pem,required=true make sign-coordinator coordinator-noenclave

FROM ghcr.io/edgelesssys/edgelessrt-deploy AS release
LABEL description="EdgelessCoordinator"
COPY --from=build /coordinator/build/coordinator-enclave.signed /coordinator/build/coordinator-noenclave /coordinator/build/coordinator-config.json /coordinator/dockerfiles/start.sh /
ENTRYPOINT ["/start.sh"]