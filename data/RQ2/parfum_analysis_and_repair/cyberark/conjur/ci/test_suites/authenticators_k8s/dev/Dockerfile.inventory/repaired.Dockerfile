ARG INVENTORY_BASE_TAG

FROM $INVENTORY_BASE_TAG

# allow anyone to write to this dir, container may not run as root
RUN mkdir -p /etc/conjur/ssl && chmod 777 /etc/conjur/ssl