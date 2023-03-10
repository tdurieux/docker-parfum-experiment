FROM runmymind/docker-android-sdk:alpine-standalone

ENV BUNDLETOOL_VERSION 0.10.1

RUN /opt/android-sdk-linux/tools/bin/sdkmanager "platforms;android-27" "build-tools;27.0.3"

RUN /opt/android-sdk-linux/tools/bin/sdkmanager "platforms;android-28" "build-tools;28.0.3"

RUN /opt/android-sdk-linux/tools/bin/sdkmanager "platforms;android-29" "build-tools;29.0.3"

RUN /opt/android-sdk-linux/tools/bin/sdkmanager --install "ndk;21.3.6528147" --channel=0

RUN apk add --no-cache bash --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main/ libuv nodejs npm openssh-client yarn

# Install bundletool
ADD https://github.com/google/bundletool/releases/download/${BUNDLETOOL_VERSION}/bundletool-all-${BUNDLETOOL_VERSION}.jar /usr/bin/bundletool.jar
RUN echo -e "#!/bin/sh\nDIR=\$(dirname \$0)\njava -jar \$DIR/bundletool.jar \$@" > /usr/bin/bundletool && \
    chmod +x /usr/bin/bundletool