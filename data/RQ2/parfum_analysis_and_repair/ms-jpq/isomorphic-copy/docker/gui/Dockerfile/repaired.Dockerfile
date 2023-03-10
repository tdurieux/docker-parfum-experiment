FROM msjpq/kde-vnc:focal


# Requirements
RUN apt update && \
    apt install --no-install-recommends -y python3 xclip && \
    apt clean && \
    export XDG_CONFIG_HOME="$HOME/.config" && \
    mkdir -p "$XDG_CONFIG_HOME/isomorphic-copy" && rm -rf /var/lib/apt/lists/*;


# Install
COPY .    /config/.config/isomorphic-copy/
WORKDIR   /config/.config/isomorphic-copy/
ENV PATH="/config/.config/isomorphic-copy/bin:$PATH" \
    ISOCP_USE_FILE=1

