# This is an example docker file on how to install the package successfully
# You can either build a custom image using this file or inject the
# dependancies using the following one line command on a running instance:

# Find the container name using docker ps and insert where <container-name> is
# docker exec -it --user=root <container-name> apk add python g++ build-base cairo-dev jpeg-dev pango-dev musl-dev giflib-dev pixman-dev pangomm-dev libjpeg-turbo-dev freetype-dev

# Pull the latest
FROM nodered/node-red

# Change the user to root to install packages
USER root

# Install required alpine packages
RUN apk add --no-cache python \
    g++ \
    build-base \
    cairo-dev \
    jpeg-dev \
    pango-dev \
    musl-dev \
    giflib-dev \
    pixman-dev \
    pangomm-dev \
    libjpeg-turbo-dev \
    freetype-dev

# Finally install the face recognition package
RUN npm i node-red-contrib-face-recognition && npm cache clean --force;

# Change the user back to node-red
USER node-red
