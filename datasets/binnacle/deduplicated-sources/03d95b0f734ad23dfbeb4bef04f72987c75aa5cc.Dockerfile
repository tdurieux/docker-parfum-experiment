FROM alvrme/alpine-android-base
LABEL maintainer="Álvaro S. <alvaro@alvr.me>"

ENV BUILD_TOOLS "25.0.3"
ENV TARGET_SDK "25"

# Install SDK Packages
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;${BUILD_TOOLS}" "platforms;android-${TARGET_SDK}"