FROM joynr-java:latest

USER root
###################################################
# install android sdk
###################################################
RUN dnf install -y \
    glibc.i686 \
    glibc-devel.i686 \
    libstdc++.i686 \
    zlib-devel.i686 \
    ncurses-devel.i686 \
    && dnf clean all

COPY scripts/build/* /data/scripts/build/
RUN chmod 777 -R /data/scripts/build/

ENV ANDROID_SDK_FILENAME sdk-tools-linux-4333796.zip
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/${ANDROID_SDK_FILENAME}
ENV ANDROID_API_LEVEL android-26
ENV ANDROID_BUILD_TOOLS_VERSION 26.0.3
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
RUN cd /opt \
    && mkdir -p ${ANDROID_HOME} \
    && cd ${ANDROID_HOME} \
    && wget -q ${ANDROID_SDK_URL} \
    && unzip -q ${ANDROID_SDK_FILENAME} \
    && rm ${ANDROID_SDK_FILENAME}

RUN chown -R root:root ${ANDROID_HOME} \
    && chmod -R 755 ${ANDROID_HOME}
# set this date to cause android to be updated
ENV REFRESHED_ANDROID_AT 2018-10-23
RUN /data/scripts/build/setup-android.sh

RUN date -R > /data/timestamp
