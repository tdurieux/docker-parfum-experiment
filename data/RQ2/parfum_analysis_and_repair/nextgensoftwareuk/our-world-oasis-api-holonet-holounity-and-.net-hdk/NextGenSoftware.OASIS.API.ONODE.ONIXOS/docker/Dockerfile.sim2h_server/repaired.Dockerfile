ARG DOCKER_BRANCH=master
FROM holochain/holonix:minimal.${DOCKER_BRANCH} as build

ENV shellfile ./default.nix

RUN nix-env -f $shellfile -iA holochain.sim2h_server
RUN nix-collect-garbage

# https://stackoverflow.com/questions/22713551/how-to-flatten-a-docker-image#22714556
FROM scratch
COPY --from=build / /
WORKDIR /holonix

RUN mkdir /tmp/sim2h -p

CMD RUST_LOG=debug sim2h_server -p 9000 > /tmp/sim2h/log.txt 2>&1