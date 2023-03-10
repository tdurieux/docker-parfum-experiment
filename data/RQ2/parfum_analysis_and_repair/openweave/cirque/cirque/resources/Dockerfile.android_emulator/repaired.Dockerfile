FROM ubuntu:18.04

ARG TZ
ENV TIMEZONE=${TZ:-America/Los_Angeles}
USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    	dnsmasq \
    	iproute2 \
	net-tools \
	iputils-ping \
    	openjdk-8-jdk \
	tzdata \
	wget \
	unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

RUN wget 'https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip' -P /tmp && \
    unzip -d /opt/android /tmp/sdk-tools-linux-4333796.zip && \
    rm -v /tmp/sdk-tools-linux-4333796.zip && \
    yes Y | /opt/android/tools/bin/sdkmanager --install \
    	"platform-tools" \
	"system-images;android-30;google_apis;x86" \
	"platforms;android-30" \
	"emulator" && \
    yes Y | /opt/android/tools/bin/sdkmanager --licenses && \
    echo "no" | /opt/android/tools/bin/avdmanager --verbose create avd --force \
    	--name "emulator" \
	--device "pixel" \
	--package "system-images;android-30;google_apis;x86" \
	--tag "google_apis" \
	--abi "x86"

COPY android_init.sh /

ENV ANDROID_HOME=/opt/android
ENV PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH
ENV LD_LIBRARY_PATH=$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib:$LD_LIBRARY_PATH
ENV QT_DEBUG_PLUGINS=1

RUN echo "export LD_LIBRARY_PATH=$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib" >> /root/.bashrc

ENTRYPOINT ["/android_init.sh"]