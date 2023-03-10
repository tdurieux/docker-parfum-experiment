FROM openjdk:8-buster

WORKDIR project/

# Install Build Essentials
RUN apt-get update \
    && apt-get install build-essential -y

RUN apt-get install jq -y
RUN apt-get install less -y

# Set Environment Variables
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_VERSION=29

ENV PATH="/root/go/bin:$PATH"

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && mkdir "$ANDROID_HOME/licenses" || true \
    && echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license" \
    && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Install Android Build Tool and Libraries
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;29.0.2" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

# Add platformtools/adb to the path
ENV PATH="$ANDROID_HOME/platform-tools:$PATH"

#Install go and github-release app
#Tempory comment out
RUN apt-get install -y golang
RUN go get github.com/github-release/github-release

#Required for Amazon App Store Release
RUN apt-get install -y jq
RUN apt-get install less -y

CMD ["/bin/bash"]