FROM openjdk:11-jdk-buster

# OS setup
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y gradle jq git-core build-essential openssl libssl-dev && rm -rf /var/lib/apt/lists/*;

# Android tools
WORKDIR /sdk
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip -q
RUN unzip -q commandlinetools-linux-8092744_latest.zip
RUN rm commandlinetools-linux-8092744_latest.zip
RUN cd cmdline-tools \
    && mkdir tools \
    && mv lib bin source.properties tools

ENV ANDROID_HOME=/sdk
ENV PATH="${PATH}:/sdk/cmdline-tools/tools:/sdk/cmdline-tools/tools/bin"

RUN yes | sdkmanager "platform-tools" "build-tools;28.0.3"
ENV PATH="${PATH}:/sdk/platform-tools"

ENV ANDROID_HOME="/sdk/"
ENV GRADLE_OPTS="-Dorg.gradle.daemon=false"

# Pre-download Gradle
ENV GRADLE_USER_HOME="/app/gradle"
WORKDIR /app/gradle

# TODO: Not convinced this is actually saving repeat downloads as it is intended to do
RUN wget -q https://services.gradle.org/distributions/gradle-5.1.1-all.zip \
            https://services.gradle.org/distributions/gradle-5.4.1-all.zip \
            https://services.gradle.org/distributions/gradle-6.2-all.zip
