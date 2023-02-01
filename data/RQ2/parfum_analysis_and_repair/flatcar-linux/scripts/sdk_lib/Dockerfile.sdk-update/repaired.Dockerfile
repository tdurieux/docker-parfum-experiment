ARG BASE

FROM ${BASE}
COPY --chown=sdk:sdk sdk_container/ /mnt/host/source
COPY --chown=sdk:sdk . /mnt/host/source/src/scripts

# Disable all sandboxing for SDK updates since some core packages
#  (like GO) fail to build from a permission error otherwise.
RUN cp /home/sdk/.bashrc /home/sdk/.bashrc.bak
RUN echo 'export FEATURES="-sandbox -usersandbox -ipc-sandbox -network-sandbox -pid-sandbox"' \
        >> /home/sdk/.bashrc

RUN chown sdk:sdk /mnt/host/source
RUN /home/sdk/sdk_entry.sh ./update_chroot --toolchain_boards="amd64-usr arm64-usr"

RUN /home/sdk/sdk_entry.sh ./setup_board --board="arm64-usr" --regen_configs
RUN /home/sdk/sdk_entry.sh ./setup_board --board="amd64-usr" --regen_configs

# Restore original .bashrc to remove sandbox disablement
RUN mv /home/sdk/.bashrc.bak /home/sdk/.bashrc
RUN chown sdk:sdk /home/sdk/.bashrc