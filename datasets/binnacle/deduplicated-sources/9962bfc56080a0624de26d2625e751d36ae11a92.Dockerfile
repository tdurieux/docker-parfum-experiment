FROM holochain/holochain-rust:circle.01.warm.nix

RUN nix-shell --run hc-test
