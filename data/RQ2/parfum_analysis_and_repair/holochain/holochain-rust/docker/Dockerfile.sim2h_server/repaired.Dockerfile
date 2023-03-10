ARG DOCKER_BRANCH=develop
FROM holochain/holochain-rust:minimal.${DOCKER_BRANCH} as build

ENV shellfile ./docker/sim2h_server.default.nix

RUN echo $CARGO_HOME

RUN NIXPKGS_ALLOW_UNFREE=1 nix-env -iA nixpkgs.newrelic-sysmond
RUN NIXPKGS_ALLOW_UNFREE=1 nix-shell $shellfile --run hc-sim2h-server-install
RUN NIXPKGS_ALLOW_UNFREE=1 nix-shell $shellfile --run 'cargo clean'
RUN NIXPKGS_ALLOW_UNFREE=1 nix-collect-garbage
RUN NIXPKGS_ALLOW_UNFREE=1 nix-shell $shellfile --run 'nrsysmond'

# https://stackoverflow.com/questions/22713551/how-to-flatten-a-docker-image#22714556
FROM scratch
COPY --from=build / /
WORKDIR /holochain
ENV CARGO_HOME /holochain/.cargo
ENV PATH "${CARGO_HOME}/bin:${PATH}"
# this should contain all our freshly built binaries
RUN ls /holochain/.cargo/bin

RUN mkdir /tmp/sim2h -p

CMD sim2h_server -p 9000 -s 20 > /tmp/sim2h/log.txt 2>&1