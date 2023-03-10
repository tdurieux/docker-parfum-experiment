FROM debian:9

# Docker build arguments
ARG SOURCE_DIR=/repo
ARG ARTIFACT_DIR=/dist
ARG ANDROID_DIR=/usr/lib/android-sdk

# Docker run environment
ENV SOURCE_DIR=/repo
ENV ARTIFACT_DIR=/dist
ENV ANDROID_DIR=/usr/lib/android-sdk

# Prepare Debian build environment
RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list.d/backports.list \
 && apt-get update \
 && apt-get install --no-install-recommends -y mmv wget unzip git \
 && apt-get install --no-install-recommends -t stretch-backports -y npm android-sdk && rm -rf /var/lib/apt/lists/*;

# Install Android repository tools
RUN rm -rf ${ANDROID_DIR}/tools \
 && wget https://dl-ssl.google.com/android/repository/tools_r25.2.3-linux.zip -O tools.zip \
 && unzip tools.zip -d ${ANDROID_DIR}/ \
 && rm -f tools.zip

# Install SDK tools
# https://stackoverflow.com/questions/38096225/automatically-accept-all-sdk-licences/42125740#42125740
# There will be a delay during the license prompt for about thirty seconds
RUN yes | ${ANDROID_DIR}/tools/bin/sdkmanager "platform-tools" "platforms;android-27" "build-tools;27.0.3" "extras;android;m2repository" "extras;google;m2repository"

# Update NPM
RUN npm install -g npm@latest && npm cache clean --force;

# Link to docker-build script
RUN ln -sf ${SOURCE_DIR}/docker-build.sh /docker-build.sh

# Prepare artifact volume
VOLUME ${ARTIFACT_DIR}/

# Copy repository
COPY . ${SOURCE_DIR}/

# Set docker-build entrypoint
ENTRYPOINT ["/docker-build.sh"]
