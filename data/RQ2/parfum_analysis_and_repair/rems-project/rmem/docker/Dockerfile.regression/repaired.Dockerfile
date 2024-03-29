FROM rmem/text

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG GUEST_UID=1000
ARG GUEST_GID=${GUEST_UID}
ARG GUEST_USER=rems
ARG GUEST_GROUP=${GUEST_USER}

COPY --from=litmus-tests --chown=${GUEST_UID}:${GUEST_GID} /home/${GUEST_USER} /home/${GUEST_USER}/