# This is an example docker file on how to install the package successfully
# You can either build a custom image using this file or inject the
# dependancies using the following one line command on a running instance:

# To start you need to buold the official debian docker image found on teh official repo:
# https://github.com/node-red/node-red-docker/blob/master/docker-custom/Dockerfile.debian


# Pull the latest
FROM testing:node-red-build

# Change the user to root to install packages
USER root

# Install required alpine packages
RUN apt-get install --no-install-recommends -y python \
    g++ \
    build-essential \
    libcairo2-dev \
    libjpeg-dev && rm -rf /var/lib/apt/lists/*;

# Optionally if your architecture supports it
# RUN npm install @tensorflow/tfjs-core@1.2.11 \
#     @tensorflow/tfjs-node@1.2.11 \

# Finally install the face recognition package
RUN npm install node-red-contrib-face-recognition && npm cache clean --force;

# Change the user back to node-red
USER node-red