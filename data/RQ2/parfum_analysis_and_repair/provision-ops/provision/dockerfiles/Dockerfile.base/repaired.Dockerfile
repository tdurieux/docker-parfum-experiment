FROM ubuntu:16.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install \
    git-core \
    nano \
    rsync \
    sudo \
    unzip \
    vim \
    wget && rm -rf /var/lib/apt/lists/*;

ENV PROVISION_BASE_USER_UID 9999
ENV PROVISION_BASE_USER_NAME provision
ENV SERVER_NAME server_master
ENV RUN_PREFIX '𝙋𝙍𝙊𝙑𝙄𝙎𝙄𝙊𝙉 Dockerfile.base ║'

RUN echo "$RUN_PREFIX Creating user $PROVISION_BASE_USER_NAME with UID $PROVISION_BASE_USER_UID and GID $PROVISION_BASE_USER_UID. This can be changed by using the Dockerfile.user image to generate a new image."
RUN addgroup --gid $PROVISION_BASE_USER_UID $PROVISION_BASE_USER_NAME
RUN adduser --uid $PROVISION_BASE_USER_UID --gid $PROVISION_BASE_USER_UID --system --home /var/$PROVISION_BASE_USER_NAME $PROVISION_BASE_USER_NAME

RUN echo "$RUN_PREFIX Creating set-user-ids script..."
COPY set-user-ids.sh /usr/local/bin/set-user-ids
RUN chmod +x /usr/local/bin/set-user-ids

USER $PROVISION_BASE_USER_NAME
WORKDIR /var/$PROVISION_BASE_USER_NAME

ENTRYPOINT []
CMD bash
