# ------------------ #
# -- Odin Builder -- #
# ------------------ #
ARG ODIN_IMAGE_VERSION=latest
FROM --platform=linux/amd64 mbround18/odin:${ODIN_IMAGE_VERSION} as runtime

# --------------- #
# -- Steam CMD -- #
# --------------- #
FROM steamcmd/steamcmd:ubuntu

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update                        \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y -qq \
    build-essential \
    htop net-tools nano gcc g++ gdb \
    netcat curl wget zip unzip \
    cron sudo gosu dos2unix \
    libsdl2-2.0-0 jq libc6 libc6-dev \
    && rm -rf /var/lib/apt/lists/* \
    && gosu nobody true \
    && dos2unix

RUN addgroup --system steam     \
    && adduser --system         \
      --home /home/steam        \
      --shell /bin/bash         \
      steam                     \
    && usermod -aG steam steam  \
    && chmod ugo+rw /tmp/dumps


# Container informaiton
ARG GITHUB_SHA="not-set"
ARG GITHUB_REF="not-set"
ARG GITHUB_REPOSITORY="not-set"

# User config
ENV PUID=1000                                                     \
    PGID=1000                                                     \
    # Set up timezone information
    TZ=America/Los_Angeles                                        \
    # Server Specific env variables.
    PORT="2456"                                                   \
    NAME="Valheim Docker"                                         \
    WORLD="Dedicated"                                             \
    PUBLIC="1"                                                    \
    PASSWORD=""                                                   \
    TYPE="Vanilla"                                                \
    UPDATE_ON_STARTUP="1"                                         \
    # Auto Update Configs
    AUTO_UPDATE="0"                                               \
    AUTO_UPDATE_SCHEDULE="0 1 * * *"                              \
    # Auto Backup Configs
    AUTO_BACKUP="0"                                               \
    AUTO_BACKUP_SCHEDULE="*/15 * * * *"                           \
    AUTO_BACKUP_REMOVE_OLD="1"                                    \
    AUTO_BACKUP_DAYS_TO_LIVE="3"                                  \
    AUTO_BACKUP_ON_UPDATE="0"                                     \
    AUTO_BACKUP_ON_SHUTDOWN="0"                                   \
    AUTO_BACKUP_PAUSE_WITH_NO_PLAYERS="0"                         \
    SCHEDULED_RESTART="0"                                         \
    SCHEDULED_RESTART_SCHEDULE="0 2 * * *"                        \
    # Folders and file system related
    SAVE_LOCATION="/home/steam/.config/unity3d/IronGate/Valheim"  \
    MODS_LOCATION="/home/steam/staging/mods"                      \
    GAME_LOCATION="/home/steam/valheim"                           \
    BACKUP_LOCATION="/home/steam/backups"                         \
    # Webhook Information
    WEBHOOK_STATUS_SUCCESSFUL="1"                                 \
    WEBHOOK_STATUS_FAILED="1"

COPY ./src/scripts/*.sh /home/steam/scripts/
COPY ./src/scripts/entrypoint.sh /entrypoint.sh
COPY ./src/scripts/env.sh /env.sh
COPY --from=runtime /apps/odin /apps/huginn /usr/local/bin/
COPY ./src/scripts/steam_bashrc.sh /home/steam/.bashrc

RUN usermod -u ${PUID} steam                            \
    && groupmod -g ${PGID} steam                        \
    && printf "${GITHUB_SHA}\n${GITHUB_REF}\n${GITHUB_REPOSITORY}\n" >/home/steam/.version \
    && chmod 755 -R /home/steam/scripts/                \
    && chmod 755 /entrypoint.sh                         \
    && chmod 755 /env.sh                                \
    && chmod 755 /usr/local/bin/odin                    \
    && dos2unix /entrypoint.sh /home/steam/.bashrc  /home/steam/scripts/*.sh


HEALTHCHECK --interval=1m --timeout=3s \
    CMD pidof valheim_server.x86_64 || exit 1

ENTRYPOINT ["/bin/bash","/entrypoint.sh"]
CMD ["/bin/bash", "/home/steam/scripts/start_valheim.sh"]
