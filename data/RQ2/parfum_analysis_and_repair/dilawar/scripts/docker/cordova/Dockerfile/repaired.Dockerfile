FROM bitriseio/docker-android:latest
RUN apt-get update -qq

# ------------------------------------------------------
# --- Cordova CLI
RUN npm install -g cordova && npm cache clean --force;
RUN cordova -v

# Cleaning
RUN apt-get clean

ENV BITRISE_DOCKER_REV_NUMBER_ANDROID_CORDOVA 2016_01_24_1
CMD bitrise -version
