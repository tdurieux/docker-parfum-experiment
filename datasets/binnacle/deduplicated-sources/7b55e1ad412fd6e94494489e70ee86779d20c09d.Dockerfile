FROM openjdk:8-jdk-stretch

RUN apt-get update

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update
RUN apt-get install -y nodejs make g++ yarn

WORKDIR /app/test/expo/features/fixtures/test-app

RUN mkdir -p /app/test/expo/features/fixures/build

RUN yarn global add gulp-cli node-gyp
RUN yarn add bunyan turtle-cli

RUN node_modules/.bin/turtle setup:android

COPY test/expo/features/fixtures/test-app .

CMD EXPO_ANDROID_KEYSTORE_PASSWORD=password \
    EXPO_ANDROID_KEY_PASSWORD=password \
    node_modules/.bin/turtle build:android \
    --keystore-path fakekeys.jks \
    --keystore-alias password \
    --output /app/test/expo/features/fixtures/build/output.apk \
    --release-channel $EXPO_RELEASE_CHANNEL