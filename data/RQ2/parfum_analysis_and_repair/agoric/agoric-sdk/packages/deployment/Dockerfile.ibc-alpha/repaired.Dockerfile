ARG SDK_TAG=latest
FROM agoric/agoric-sdk:$SDK_TAG
ENTRYPOINT [ "/usr/src/agoric-sdk/packages/cosmic-swingset/scripts/chain-entry.sh", "single-node" ]