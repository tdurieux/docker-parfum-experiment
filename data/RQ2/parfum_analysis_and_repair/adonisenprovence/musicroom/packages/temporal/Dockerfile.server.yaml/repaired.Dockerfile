FROM temporalio/auto-setup:1.14.3

# Docker context is set to the root of this repo
COPY packages/temporal/config/dynamicconfig.yaml /etc/temporal/dynamicconfig.yaml
COPY packages/temporal/auto-setup.sh .