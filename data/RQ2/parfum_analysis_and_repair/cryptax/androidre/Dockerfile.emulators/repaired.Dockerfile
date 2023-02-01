# ------------------------- Android RE environment image
FROM ubuntu:20.04

MAINTAINER Axelle Apvrille
ENV REFRESHED_AT 2021-02-22

ARG DEBIAN_FRONTEND=noninteractive
ARG SSH_PASSWORD
ARG VNC_PASSWORD
ARG JDK_VERSION=8
ENV ANDROID_SDK_VERSION "6858069"

# docker run --name latest-ubuntu --network=host -e DISPLAY=$DISPLAY --rm -it ubuntu:20.04
RUN apt-get update && apt-get install --no-install-recommends -yqq openjdk-${JDK_VERSION}-jdk libpulse0 libxcursor1 adb \
    git build-essential supervisor wget unzip zip \
    iptables iputils-ping \
    libxml2-dev libxslt-dev \
    openssh-server ssh \
    xvfb x11vnc xfce4 && rm -rf /var/lib/apt/lists/*;

# --------------------- Android SDK and emulators
ENV ANDROID_SDK_ROOT /opt/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT} && wget -q -O "/opt/android-sdk/tools-linux.zip" https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && unzip /opt/android-sdk/tools-linux.zip -d $ANDROID_SDK_ROOT && rm -f  /opt/android-sdk/tools-linux.zip && cd ${ANDROID_SDK_ROOT}/cmdline-tools && mkdir -p tools/latest && mv bin/* ./tools/latest && mv lib/ tools && rmdir bin
ENV PATH $PATH:${ANDROID_SDK_ROOT}/cmdline-tools/tools/latest
RUN echo y | sdkmanager --update
RUN yes |  sdkmanager --licenses
RUN echo "yes" | sdkmanager "emulator" \
    "tools" \
    "platform-tools" \
    "build-tools;31.0.0-rc1" \
    "platforms;android-22" \
    "platforms;android-30" \
    "system-images;android-22;google_apis;armeabi-v7a" \
    "system-images;android-30;google_apis;x86_64"

RUN echo "no" | avdmanager create avd -n "Android51" -k "system-images;android-22;google_apis;armeabi-v7a"
RUN echo "no" | avdmanager create avd -n "Android11_x86_64" -k "system-images;android-30;google_apis;x86_64"
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:${ANDROID_SDK_ROOT}/emulator/lib64:${ANDROID_SDK_ROOT}/emulator/lib64/qt/lib

# for the "root without --no-sandbox" bug
ENV QTWEBENGINE_DISABLE_SANDBOX 1

# ------------------------ Dexcalibur -----------------------------------------------------
ENV FRIDA_SERVER frida-server-14.2.13-android-x86_64.xz
RUN apt install --no-install-recommends -yqq curl dirmngr apt-transport-https lsb-release ca-certificates \
        python3-pip python && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir frida-tools
RUN npm install -g npm && npm install -g dexcalibur && npm cache clean --force;
RUN mkdir -p /workshop && wget -q -O /workshop/${FRIDA_SERVER} https://github.com/frida/frida/releases/download/14.2.13/${FRIDA_SERVER} && cd /workshop && unxz ${FRIDA_SERVER}

# ------------------------ Install SSH access ---------------------------------------------
RUN mkdir /var/run/sshd \
    && echo "root:${SSH_PASSWORD}" | chpasswd \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# SSH login fix. Otherwise user is kicked off after login

# ------------------------- Install VNC server - we need GLX support for Android emulator
COPY ./setup/startXvfb.sh /root/startXvfb.sh
RUN mkdir ~/.vnc \
    && x11vnc -storepasswd ${VNC_PASSWORD} ~/.vnc/passwd \
    && chmod u+x /root/startXvfb.sh

# We need supervisor to launch SSH and VNC
RUN mkdir -p /var/log/supervisor
COPY ./setup/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN echo "export PATH=$PATH" >> /etc/profile \
     && echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" >> /etc/profile \
     && echo "export QTWEBENGINE_DISABLE_SANDBOX=1" >> /etc/profile
RUN echo "alias emulator5='/opt/android-sdk/emulator/emulator -avd Android51 -no-audio -partition-size 512 -no-boot-anim'" >> /root/.bashrc \
    && echo "alias emulator='/opt/android-sdk/tools/emulator -avd Android11_x86_64 -no-audio -no-boot-anim'" >> /root/.bashrc \
    && echo "export LC_ALL=C" >> /root/.bashrc

# ------------------------- Clean up

RUN apt-get clean && apt-get autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /usr/share/doc/* > /dev/null 2>&1

# ------------------------- Final matter

WORKDIR /workshop
VOLUME ["/data"] # to be used for instance to pass along samples
CMD [ "/usr/bin/supervisord", "-c",  "/etc/supervisor/conf.d/supervisord.conf" ]

EXPOSE 5554
EXPOSE 5555
EXPOSE 5900
EXPOSE 5037
EXPOSE 8000
EXPOSE 22
