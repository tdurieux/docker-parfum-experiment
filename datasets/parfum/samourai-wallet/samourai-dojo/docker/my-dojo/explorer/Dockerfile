FROM    node:12-buster

ENV     APP_DIR              /home/node/app

ENV     EXPLORER_URL         https://github.com/janoside/btc-rpc-explorer/archive
ENV     EXPLORER_VERSION     2.0.0

# Install netcat
RUN     set -ex && \
        apt-get update && \
        apt-get install -y netcat

# Download the source code and install it
RUN     set -ex && \
        mkdir "$APP_DIR" && \
        wget -qO explorer.tar.gz "$EXPLORER_URL/v$EXPLORER_VERSION.tar.gz" && \
        tar -xzvf explorer.tar.gz -C "$APP_DIR/" --strip-components 1 && \
        rm explorer.tar.gz && \
        cd "$APP_DIR" && \
        npm install --only=prod && \
        chown -R node:node "$APP_DIR"

# Copy restart script
COPY    ./restart.sh "$APP_DIR/restart.sh"

RUN     chown node:node "$APP_DIR/restart.sh" && \
        chmod u+x "$APP_DIR/restart.sh" && \
        chmod g+x "$APP_DIR/restart.sh"

EXPOSE  3002

USER    node