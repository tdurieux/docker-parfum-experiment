FROM ubuntu:20.04

RUN apt-get update > /dev/n && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y wget maven gnupg1 cppcheck libncurses5 jq clang-format unzip curl git && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean > /dev/null

ENV ANDROID_SDK_ROOT="/sdk"
ENV ANDROID_CMDLINE_TOOLS="${ANDROID_SDK_ROOT}/cmdline-tools/latest"
ENV PATH="${PATH}:${ANDROID_CMDLINE_TOOLS}/bin"
ENV CMDLINE_TOOLS_NAME="commandlinetools-linux-6858069_latest.zip"
WORKDIR $ANDROID_SDK_ROOT

# Generate signing key
COPY features/scripts/generate_gpg_key generate_gpg_key
RUN gpg1 --gen-key --batch generate_gpg_key
RUN mkdir ~/.gradle
RUN gpg1 --list-keys | awk -F '[/\ ]' 'FNR==3{printf "signing.keyId=%s\n", $5}' >> ~/.gradle/gradle.properties
RUN echo "signing.password=password" >> ~/.gradle/gradle.properties
RUN echo "signing.secretKeyRingFile=/root/.gnupg/secring.gpg" >> ~/.gradle/gradle.properties

# Download Android command line tools
RUN wget https://dl.google.com/android/repository/${CMDLINE_TOOLS_NAME} -q
RUN mkdir cmdline-tools
RUN unzip -q ${CMDLINE_TOOLS_NAME} -d /sdk/cmdline-tools
RUN mv /sdk/cmdline-tools/cmdline-tools $ANDROID_CMDLINE_TOOLS
RUN rm $CMDLINE_TOOLS_NAME

# Install Android tools using sdkmanager
RUN yes | sdkmanager "platform-tools" > /dev/null
RUN yes | sdkmanager "platforms;android-31" > /dev/null
RUN yes | sdkmanager "ndk;16.1.4479499" > /dev/null
RUN yes | sdkmanager "ndk;17.2.4988734" > /dev/null
RUN yes | sdkmanager "ndk;19.2.5345600" > /dev/null
RUN yes | sdkmanager "ndk;21.4.7075529" > /dev/null

RUN yes | sdkmanager "cmake;3.6.4111459" > /dev/null
RUN yes | sdkmanager "cmake;3.10.2.4988404" > /dev/null
RUN yes | sdkmanager "build-tools;30.0.3" > /dev/null

# Install bundletool
RUN wget -q https://github.com/google/bundletool/releases/download/1.4.0/bundletool-all-1.4.0.jar
RUN mv bundletool-all-1.4.0.jar bundletool.jar
