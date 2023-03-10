FROM ubuntu:16.04
MAINTAINER @FrenchYeti "frenchyeti@protonmail.com"

RUN useradd -ms /bin/bash dexcalibur

# support multiarch: i386 architecture
# install Java
# install essential tools
# install Nodejs
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y libncurses5:i386 libc6:i386 libstdc++6:i386 lib32gcc1 lib32ncurses5 lib32z1 zlib1g:i386 && \
    apt-get install -y --no-install-recommends openjdk-8-jdk && \
    apt-get install --no-install-recommends -y git wget zip curl autotools-dev automake && \
	apt-get install --no-install-recommends -y usbutils python3 python3-dev python3-pip gcc-multilib && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -y && \
	apt-get install --no-install-recommends -y nodejs && \
	nodejs -v && \
	npm -v && rm -rf /var/lib/apt/lists/*;

# download and install Gradle
# https://services.gradle.org/distributions/
ARG GRADLE_VERSION=4.10.3
RUN cd /opt && \
    wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle*.zip && \
    ls -d */ | sed 's/\/*$//g' | xargs -I{} mv {} gradle && \
    rm gradle*.zip


# download and install Android SDK
# https://developer.android.com/studio/#downloads
# ARG ANDROID_SDK_VERSION=4333796
# RUN mkdir -p /opt/android-sdk && cd /opt/android-sdk && \
# 	wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
#	unzip *tools*linux*.zip && \
#	rm *tools*linux*.zip


# set the environment variables
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV GRADLE_HOME /opt/gradle
ENV ANDROID_HOME /opt/android-sdk
# ENV PATH ${PATH}:${GRADLE_HOME}/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin
ENV PATH ${PATH}:${GRADLE_HOME}/bin
ENV _JAVA_OPTIONS -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap

# accept the license agreements of the SDK components
# ADD license_accepter.sh /opt/
# RUN /opt/license_accepter.sh $ANDROID_HOME

# setup adb and dexcalibur server
EXPOSE 5037 8000 31415



# Install android tools + sdk
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH $PATH:${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools

# Install APKTool
RUN mkdir -p /home/dexcalibur/tools/apktool && \
	cd /home/dexcalibur/tools/apktool && \
	wget -q https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool && \
	wget -q https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.4.0.jar && \
	mv *.jar apktool.jar && \
	mv apktool* /usr/local/bin/. && \
	chmod +x /usr/local/bin/apktool*


# RUN wget -qO- "http://dl.google.com/android/android-sdk_r24.3.4-linux.tgz" | tar -zx -C /opt && \
#     echo y | android update sdk --no-ui --all --filter platform-tools --force

# install platform-tools (ADB)
RUN head -c 5 /dev/random > random_bytes2 && mkdir /home/dexcalibur/platform-tools/ && \ 
	cd /home/dexcalibur/platform-tools/ && \
	wget -q https://dl.google.com/android/repository/platform-tools-latest-linux.zip && \
	unzip *.zip && \
	rm *.zip

ENV PATH ${PATH}:${GRADLE_HOME}/bin:/home/dexcalibur/platform-tools/platform-tools
RUN echo 'adb forward tcp:31415 tcp:31415' >> /home/dexcalibur/.bashrc

#Install Frida
RUN pip3 install --no-cache-dir colorama prompt-toolkit pygments
RUN pip3 install --no-cache-dir frida
RUN pip3 install --no-cache-dir frida-tools


# Setup Dexcalibur
WORKDIR /home/dexcalibur

RUN head -c 5 /dev/random > random_bytes && git clone https://github.com/FrenchYeti/dexcalibur.git && \
	cd /home/dexcalibur/dexcalibur && \
	/usr/bin/npm install && /usr/bin/npm uninstall frida && /usr/bin/npm install frida@12.6.1

ADD docker/config.js dexcalibur/config.js



WORKDIR /home/dexcalibur/dexcalibur
VOLUME ["/home/dexcalibur/workspace"]
CMD ["/bin/sh"]
