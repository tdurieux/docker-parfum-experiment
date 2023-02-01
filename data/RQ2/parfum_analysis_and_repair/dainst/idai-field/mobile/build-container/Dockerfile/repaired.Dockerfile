FROM openjdk:8

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install --global --unsafe-perm turtle-cli && npm cache clean --force;


RUN turtle setup:android --sdk-version 40.0.0

ENV EXPO_ANDROID_KEYSTORE_PASSWORD="keystorepassword"
ENV EXPO_ANDROID_KEY_PASSWORD="keypassword"

WORKDIR /mobile
ENTRYPOINT [ "sh","./build-container/entrypoint.sh" ]