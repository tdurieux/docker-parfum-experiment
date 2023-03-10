ARG RKE2_VERSION=v1.20.7-rke2r2
# If you are changing RKE2_VERSION here, be sure to also change in rancher/cmd/rancherd/go.mod
# And change the 3 RKE2 environment variables in rancher/scripts/build-rancherd below RKE2_VERSION
FROM rancher/rke2-runtime:${RKE2_VERSION}
COPY rancher.yaml rancher-namespace.yaml /charts/