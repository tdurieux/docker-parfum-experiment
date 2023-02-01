FROM phusion/baseimage:0.9.12
MAINTAINER Nicolas Pace <nicolas.pace@unixono.com.ar>

# Set correct environment variables.
ENV HOME /root
ENV ANDROID_SDK_FILENAME android-sdk_r23.0.2-linux.tgz
ENV ANDROID_SDK http://dl.google.com/android/$ANDROID_SDK_FILENAME

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]


# Install Oracle Java
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
RUN apt-get -y install oracle-java7-installer

# ...put your own build instructions here...
# RUN apt-get update

## Create a user for the web app.
RUN addgroup --gid 9999 app
RUN adduser --uid 9999 --disabled-password --gid 9999 --gecos "Application" app
# RUN echo app | passwd app --stdin
RUN echo "app:app" | chpasswd

# Android Install
# adb dependencies
#
RUN apt-get install -y ant expect wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /opt && \
    wget $ANDROID_SDK && \
    tar -xzvf $ANDROID_SDK_FILENAME && \
    export ANDROID_HOME=/opt/android-sdk-linux && \
    export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools && \
    chgrp -R users /opt/android-sdk-linux && chmod -R 0775 /opt/android-sdk-linux && \
    rm $ANDROID_SDK_FILENAME

RUN echo -e  "export ANDROID_HOME=/opt/android-sdk-linux \nexport PATH=\$PATH:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/platform-tools" >> /etc/profile.d/android.sh

RUN expect -c ' \
set timeout -1;\
spawn /opt/android-sdk-linux/tools/android update sdk -u --all --filter platform-tool,android-19,build-tools-19.1.0 \
expect { \
    "Do you accept the license" { exp_send "y\r" ; exp_continue } \
    eof\
}\
'

# # Ionic Install
# # ionic dependencies
# RUN apt-get install -y nodejs npm git && \
#     apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# 
# # So ubuntu doesn't freak out about nodejs path, which is just silly
# RUN ln -s /usr/bin/nodejs /usr/bin/node
# 
# RUN npm install -g cordova
# RUN npm install -g ionic
# 
# # Add USB Support
# # usb dependencies
# RUN apt-get install -y usbutils && \
#     apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
