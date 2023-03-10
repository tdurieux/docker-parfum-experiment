FROM cirrusci/flutter:stable

ENV EMULATOR_API_LEVEL=28 ABI="default;x86" EMULATOR_NAME='NEXUS_6P_API_28'

RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y imagemagick && \
    sudo rm -rf /var/lib/apt/lists/*

RUN sdkmanager --update && sdkmanager "system-images;android-$EMULATOR_API_LEVEL;$ABI"

RUN echo no | avdmanager create avd -n $EMULATOR_NAME -k "system-images;android-$EMULATOR_API_LEVEL;$ABI"

#ADD .ci/config.ini $HOME/.android/avd/$EMULATOR_NAME.avd/config.ini
