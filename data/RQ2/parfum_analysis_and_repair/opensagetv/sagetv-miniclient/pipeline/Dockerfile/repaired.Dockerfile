FROM openjdk:8-buster

WORKDIR project/

# Install Build Essentials
RUN apt-get update \
    && apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends jq -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends less -y && rm -rf /var/lib/apt/lists/*;

# Set Environment Variables
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_VERSION=29

ENV PATH="/root/go/bin:$PATH"

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -f -o sdk.zip $SDK_URL \
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
RUN apt-get install --no-install-recommends -y golang && rm -rf /var/lib/apt/lists/*;
RUN go get github.com/github-release/github-release

#Required for Amazon App Store Release
RUN apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends less -y && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/bash"]