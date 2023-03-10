ARG FLOOD_VERSION=latest
ARG RTORRENT_VERSION=latest

FROM docker.io/jesec/rtorrent:$RTORRENT_VERSION as rtorrent

FROM docker.io/jesec/flood:$FLOOD_VERSION as flood

# Install rTorrent
COPY --from=rtorrent / /

# Flood with managed rTorrent daemon
ENV FLOOD_OPTION_RTORRENT="true"