FROM    node:12-buster

ENV     APP_DIR     /home/node/app

# Add node user to tor group
RUN     addgroup --system -gid 1107 tor && \
        usermod -a -G tor node

# Install forever
RUN     npm install -g forever

# Create app directory
RUN     mkdir "$APP_DIR" && \
        chown -R node:node "$APP_DIR" 

# Copy app source files into APP_DIR
COPY    . "$APP_DIR"

# Install node modules required by the app
RUN     cd "$APP_DIR" && \
        npm ci --only=production

# Copy config file
COPY    ./docker/my-dojo/node/keys.index.js "$APP_DIR/keys/index.js"
RUN     chown node:node "$APP_DIR/keys/index.js"

# Copy restart script
COPY    ./docker/my-dojo/node/restart.sh "$APP_DIR/restart.sh"

RUN     chown node:node "$APP_DIR/restart.sh" && \
        chmod u+x "$APP_DIR/restart.sh" && \
        chmod g+x "$APP_DIR/restart.sh"

# Copy wait-for-it script
COPY    ./docker/my-dojo/node/wait-for-it.sh "$APP_DIR/wait-for-it.sh"

RUN     chown node:node "$APP_DIR/wait-for-it.sh" && \
        chmod u+x "$APP_DIR/wait-for-it.sh" && \
        chmod g+x "$APP_DIR/wait-for-it.sh"

USER    node